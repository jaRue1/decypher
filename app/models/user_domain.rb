# frozen_string_literal: true

class UserDomain < ApplicationRecord
  belongs_to :user
  belongs_to :domain

  MAX_LEVEL = 10
  XP_PER_LEVEL = 400
  GRADES = %w[D C B A].freeze

  # Check if user can level up
  def can_level_up?
    level < MAX_LEVEL && xp >= XP_PER_LEVEL
  end

  # Level up the user in this domain
  def level_up!
    return false unless can_level_up?

    transaction do
      self.xp -= XP_PER_LEVEL
      self.level += 1
      self.current_grade = "D"
      self.level_started_at = Time.current
      save!

      # Record achievement
      begin
        user.achievements.create!(
          achievement_type: "level_up",
          achievable: domain,
          metadata: { level: level, domain_name: domain.name },
          achieved_at: Time.current
        )
      rescue ActiveRecord::RecordNotUnique
        # Already recorded this achievement, skip
      end
    end

    true
  end

  # Add XP to this domain
  def add_xp(amount)
    increment!(:xp, amount)
    user.add_xp(amount)
  end

  # Advance to next grade after completing a mission
  def advance_grade!
    current_index = GRADES.index(current_grade) || 0
    return unless current_index < GRADES.length - 1

    update!(current_grade: GRADES[current_index + 1])
  end

  # Check if at max level
  def maxed?
    level >= MAX_LEVEL
  end

  # Progress percentage within current level
  def level_progress_percentage
    return 100 if maxed?

    ((xp.to_f / XP_PER_LEVEL) * 100).round
  end
end
