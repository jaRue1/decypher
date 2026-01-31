# frozen_string_literal: true

module Operator
  class DomainSetup < Base
    class PlanValidationError < StandardError; end

    def initialize(domain_setup)
      super()
      @domain_setup = domain_setup
    end

    # Generate a plan using Claude API
    def generate_plan
      system_prompt = Prompts::DomainSetupSystem.system_prompt(@domain_setup.domain)
      user_prompt = Prompts::DomainSetupSystem.user_prompt(@domain_setup)

      response = call_api(system_prompt: system_prompt, user_prompt: user_prompt)
      plan = parse_json_response(response)

      validate_plan!(plan)

      @domain_setup.update!(generated_plan: plan)
      plan
    end

    # Apply the generated plan - create all records in a transaction
    def apply_plan!
      plan = @domain_setup.generated_plan
      raise PlanValidationError, 'No plan generated' unless plan.present?

      validate_plan!(plan)

      ActiveRecord::Base.transaction do
        # Create or update UserDomain
        user_domain = create_user_domain!(plan)

        # Create goals
        create_goals!(plan)

        # Create missions with objectives
        create_missions!(plan)

        # Mark setup as completed
        @domain_setup.advance_to!('completed')

        user_domain
      end
    end

    private

    def validate_plan!(plan)
      errors = []

      # Check required keys
      %w[level_assessment goals missions].each do |key|
        errors << "Missing #{key}" unless plan[key].present?
      end

      # Check goals count (Law of Fours)
      if plan['goals'].present? && plan['goals'].length != 4
        errors << "Expected 4 goals, got #{plan['goals'].length}"
      end

      # Check missions count
      if plan['missions'].present?
        unless plan['missions'].length == 4
          errors << "Expected 4 missions, got #{plan['missions'].length}"
        end

        # Check grade distribution (must have D, C, B, A)
        grades = plan['missions'].map { |m| m['grade'] }.sort
        expected_grades = %w[A B C D]
        unless grades == expected_grades
          errors << "Expected grades D, C, B, A but got #{plan['missions'].map { |m| m['grade'] }.join(', ')}"
        end

        # Check objectives count for each mission
        plan['missions'].each_with_index do |mission, idx|
          unless mission['objectives']&.length == 4
            errors << "Mission #{idx + 1} should have 4 objectives, got #{mission['objectives']&.length || 0}"
          end
        end
      end

      raise PlanValidationError, errors.join(', ') if errors.any?
    end

    def create_user_domain!(plan)
      level = plan.dig('level_assessment', 'current_level') || 1

      @domain_setup.user.user_domains.find_or_initialize_by(domain: @domain_setup.domain).tap do |ud|
        ud.level = level
        ud.setup_completed = true
        ud.quiz_responses = { operator_generated: true, reasoning: plan.dig('level_assessment', 'reasoning') }.to_json
        ud.save!
      end
    end

    def create_goals!(plan)
      plan['goals'].each do |goal_data|
        @domain_setup.user.goals.create!(
          domain: @domain_setup.domain,
          content: goal_data['content'],
          goal_type: goal_data['goal_type'],
          timeframe: goal_data['timeframe'],
          priority: goal_data['priority'],
          status: 'active'
        )
      end
    end

    def create_missions!(plan)
      plan['missions'].each do |mission_data|
        mission = @domain_setup.user.missions.create!(
          domain: @domain_setup.domain,
          title: mission_data['title'],
          description: mission_data['description'],
          target_level: mission_data['target_level'],
          grade: mission_data['grade'],
          status: 'standby'
        )

        mission_data['objectives'].each do |obj_data|
          mission.objectives.create!(
            description: obj_data['description'],
            skill_name: obj_data['skill_name'],
            difficulty: obj_data['difficulty'],
            position: obj_data['position'],
            status: 'pending'
          )
        end
      end
    end
  end
end
