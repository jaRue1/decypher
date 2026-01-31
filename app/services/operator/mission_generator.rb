# frozen_string_literal: true

module Operator
  class MissionGenerator < Base
    class GenerationError < StandardError; end

    # Flow C: Generate missions from a goal
    def generate_from_goal(goal)
      system_prompt = mission_from_goal_system_prompt(goal)
      user_prompt = mission_from_goal_user_prompt(goal)

      response = call_api(system_prompt: system_prompt, user_prompt: user_prompt)
      missions_data = parse_json_response(response)

      validate_missions!(missions_data)

      ActiveRecord::Base.transaction do
        create_missions_for_goal!(goal, missions_data)
      end
    end

    # Flow D: Generate next mission after completing one
    def generate_next(completed_mission)
      system_prompt = next_mission_system_prompt(completed_mission)
      user_prompt = next_mission_user_prompt(completed_mission)

      response = call_api(system_prompt: system_prompt, user_prompt: user_prompt)
      mission_data = parse_json_response(response)

      validate_single_mission!(mission_data)

      create_mission!(completed_mission.user, completed_mission.domain, mission_data)
    end

    private

    def mission_from_goal_system_prompt(goal)
      <<~PROMPT
        You are "The Operator" - an AI assistant that creates structured learning missions.

        Your task is to generate exactly 4 missions to help achieve a specific goal.
        Each mission must have exactly 4 objectives.

        IMPORTANT RULES:
        - Generate EXACTLY 4 missions
        - Each mission must have EXACTLY 4 objectives
        - Missions should build progressively toward the goal
        - Objectives should be specific and actionable
        - Difficulty should progress within each mission (1 to 4)

        DIFFICULTY LEVELS:
        1 = Beginner (25 XP) - Simple introduction tasks
        2 = Intermediate (50 XP) - Building on basics
        3 = Advanced (75 XP) - Challenging application
        4 = Expert (100 XP) - Complex mastery tasks

        OUTPUT FORMAT (JSON only):
        {
          "missions": [
            {
              "title": "<mission title>",
              "description": "<mission description>",
              "target_level": <1-10>,
              "grade": "<D|C|B|A>",
              "objectives": [
                {
                  "description": "<objective description>",
                  "skill_name": "<skill to be learned>",
                  "difficulty": <1-4>,
                  "position": <1-4>
                }
              ]
            }
          ]
        }

        Respond ONLY with valid JSON.
      PROMPT
    end

    def mission_from_goal_user_prompt(goal)
      <<~PROMPT
        Generate 4 missions to help achieve this goal:

        DOMAIN: #{goal.domain&.name || 'General'}
        GOAL: #{goal.content}
        #{goal.context.present? ? "CONTEXT: #{goal.context}" : ''}
        #{goal.success_criteria.present? ? "SUCCESS CRITERIA: #{goal.success_criteria}" : ''}
        #{goal.current_blockers.present? ? "CURRENT BLOCKERS: #{goal.current_blockers}" : ''}
        TIMEFRAME: #{goal.timeframe || 'Not specified'}
        PRIORITY: #{goal.priority || 'Not specified'}

        Create 4 progressive missions with 4 objectives each that will help achieve this goal.
      PROMPT
    end

    def next_mission_system_prompt(completed_mission)
      <<~PROMPT
        You are "The Operator" - an AI assistant that creates follow-up learning missions.

        The user has completed a mission and needs the next one in their learning journey.
        Generate exactly 1 mission with exactly 4 objectives that builds on their progress.

        IMPORTANT RULES:
        - Generate EXACTLY 1 mission
        - The mission must have EXACTLY 4 objectives
        - Build on skills from the completed mission
        - Increase difficulty appropriately
        - Each objective should be specific and actionable

        DIFFICULTY LEVELS:
        1 = Beginner (25 XP)
        2 = Intermediate (50 XP)
        3 = Advanced (75 XP)
        4 = Expert (100 XP)

        OUTPUT FORMAT (JSON only):
        {
          "title": "<mission title>",
          "description": "<mission description>",
          "target_level": <1-10>,
          "grade": "<D|C|B|A>",
          "objectives": [
            {
              "description": "<objective description>",
              "skill_name": "<skill to be learned>",
              "difficulty": <1-4>,
              "position": <1-4>
            }
          ]
        }

        Respond ONLY with valid JSON.
      PROMPT
    end

    def next_mission_user_prompt(completed_mission)
      skills_learned = completed_mission.objectives.map(&:skill_name).compact.join(", ")

      <<~PROMPT
        Generate the next mission for a user who just completed:

        DOMAIN: #{completed_mission.domain.name}
        COMPLETED MISSION: #{completed_mission.title}
        DESCRIPTION: #{completed_mission.description}
        SKILLS LEARNED: #{skills_learned.presence || 'Various skills'}
        CURRENT LEVEL: #{completed_mission.target_level || 1}

        Create the next mission that builds on these skills and advances their learning.
      PROMPT
    end

    def validate_missions!(data)
      errors = []

      unless data["missions"].present? && data["missions"].length == 4
        errors << "Expected 4 missions, got #{data['missions']&.length || 0}"
      end

      data["missions"]&.each_with_index do |mission, idx|
        unless mission["objectives"]&.length == 4
          errors << "Mission #{idx + 1} should have 4 objectives"
        end
      end

      raise GenerationError, errors.join(", ") if errors.any?
    end

    def validate_single_mission!(data)
      errors = []

      errors << "Missing mission title" unless data["title"].present?
      unless data["objectives"]&.length == 4
        errors << "Expected 4 objectives, got #{data['objectives']&.length || 0}"
      end

      raise GenerationError, errors.join(", ") if errors.any?
    end

    def create_missions_for_goal!(goal, data)
      data["missions"].map do |mission_data|
        create_mission!(goal.user, goal.domain, mission_data)
      end
    end

    def create_mission!(user, domain, mission_data)
      mission = user.missions.create!(
        domain: domain,
        title: mission_data["title"],
        description: mission_data["description"],
        target_level: mission_data["target_level"],
        grade: mission_data["grade"],
        status: "standby"
      )

      mission_data["objectives"].each do |obj_data|
        mission.objectives.create!(
          description: obj_data["description"],
          skill_name: obj_data["skill_name"],
          difficulty: obj_data["difficulty"],
          position: obj_data["position"],
          status: "pending"
        )
      end

      mission
    end
  end
end
