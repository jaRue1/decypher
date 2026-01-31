# frozen_string_literal: true

module Operator
  class HabitGenerator < Base
    class GenerationError < StandardError; end

    # Generate habits for a mission
    def generate_for_mission(mission)
      system_prompt = habit_system_prompt(mission)
      user_prompt = habit_user_prompt(mission)

      response = call_api(system_prompt: system_prompt, user_prompt: user_prompt)
      habits_data = parse_json_response(response)

      validate_habits!(habits_data)

      create_habits!(mission.user, mission.domain, habits_data)
    end

    # Generate habits for a domain during setup
    def generate_for_domain_setup(domain_setup)
      system_prompt = domain_habit_system_prompt(domain_setup)
      user_prompt = domain_habit_user_prompt(domain_setup)

      response = call_api(system_prompt: system_prompt, user_prompt: user_prompt)
      habits_data = parse_json_response(response)

      validate_habits!(habits_data)

      create_habits!(domain_setup.user, domain_setup.domain, habits_data)
    end

    private

    def habit_system_prompt(mission)
      <<~PROMPT
        You are "The Operator" - an AI assistant that creates daily habits to support learning missions.

        Your task is to generate exactly 4 habits that will help the user succeed in their mission.
        These habits should be:
        - Simple and actionable (can be done daily)
        - Directly supportive of the mission objectives
        - Realistic for a 5 days per week schedule
        - Specific enough to be measurable

        IMPORTANT RULES:
        - Generate EXACTLY 4 habits
        - Each habit should have a clear, concise name (under 50 characters)
        - Target 5 days per week (weekdays)
        - Include a mix of learning, practice, and reflection habits

        OUTPUT FORMAT (JSON only):
        {
          "habits": [
            {
              "name": "<habit name - action-oriented, e.g., 'Read 20 minutes of technical docs'>",
              "target_days_per_week": 5,
              "icon": "<single emoji>",
              "color": "<hex color code>"
            }
          ]
        }

        Respond ONLY with valid JSON.
      PROMPT
    end

    def habit_user_prompt(mission)
      objectives = mission.objectives.map(&:description).join("\n- ")

      <<~PROMPT
        Generate 4 daily habits to support this mission:

        DOMAIN: #{mission.domain.name}
        MISSION: #{mission.title}
        DESCRIPTION: #{mission.description}
        GRADE: #{mission.grade}

        OBJECTIVES:
        - #{objectives}

        Create 4 habits that will help build the skills and consistency needed to complete these objectives.
        Focus on habits that can be done in 15-30 minutes daily.
      PROMPT
    end

    def domain_habit_system_prompt(domain_setup)
      <<~PROMPT
        You are "The Operator" - an AI assistant that creates daily habits to support personal development.

        Your task is to generate exactly 4 habits that will help the user progress in their domain.
        These habits should be:
        - Simple and actionable (can be done daily)
        - Directly supportive of the user's goals
        - Realistic for a 5 days per week schedule
        - Specific enough to be measurable

        IMPORTANT RULES:
        - Generate EXACTLY 4 habits
        - Each habit should have a clear, concise name (under 50 characters)
        - Target 5 days per week (weekdays)
        - Include a mix of learning, practice, and reflection habits

        OUTPUT FORMAT (JSON only):
        {
          "habits": [
            {
              "name": "<habit name - action-oriented, e.g., 'Practice coding for 30 minutes'>",
              "target_days_per_week": 5,
              "icon": "<single emoji>",
              "color": "<hex color code>"
            }
          ]
        }

        Respond ONLY with valid JSON.
      PROMPT
    end

    def domain_habit_user_prompt(domain_setup)
      <<~PROMPT
        Generate 4 daily habits to support progress in this domain:

        DOMAIN: #{domain_setup.domain.name}
        #{domain_setup.domain.description.present? ? "DESCRIPTION: #{domain_setup.domain.description}" : ''}

        USER'S GOALS:
        #{domain_setup.goals_input}

        BACKGROUND:
        #{domain_setup.background_input.presence || 'Not specified'}

        Create 4 habits that will help build consistent progress toward these goals.
        Focus on habits that can be done in 15-30 minutes daily, 5 days per week.
      PROMPT
    end

    def validate_habits!(data)
      errors = []

      unless data['habits'].present? && data['habits'].length == 4
        errors << "Expected 4 habits, got #{data['habits']&.length || 0}"
      end

      data['habits']&.each_with_index do |habit, idx|
        errors << "Habit #{idx + 1} missing name" unless habit['name'].present?
      end

      raise GenerationError, errors.join(', ') if errors.any?
    end

    def create_habits!(user, domain, data)
      data['habits'].map do |habit_data|
        user.habits.create!(
          domain: domain,
          name: habit_data['name'],
          target_days_per_week: habit_data['target_days_per_week'] || 5,
          icon: habit_data['icon'],
          color: habit_data['color'],
          active: true
        )
      end
    end
  end
end
