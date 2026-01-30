# frozen_string_literal: true

class Achievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievable, polymorphic: true, optional: true

  TYPES = %w[
    level_up
    mission_completed
    objective_completed
    badge_earned
    skill_acquired
    streak
    milestone
  ].freeze

  validates :achievement_type, presence: true, inclusion: { in: TYPES }

  scope :recent, -> { order(achieved_at: :desc) }
  scope :by_type, ->(type) { where(achievement_type: type) }
  scope :level_ups, -> { by_type('level_up') }
  scope :missions, -> { by_type('mission_completed') }
  scope :objectives, -> { by_type('objective_completed') }

  # Human-readable description
  def description
    case achievement_type
    when 'level_up'
      "Reached Level #{metadata['level']} in #{metadata['domain_name']}"
    when 'mission_completed'
      "Completed mission: #{metadata['title']}"
    when 'objective_completed'
      "Completed objective: #{metadata['description']}"
    when 'badge_earned'
      "Earned badge: #{metadata['badge_name']}"
    when 'skill_acquired'
      "Acquired skill: #{metadata['skill_name']}"
    else
      achievement_type.humanize
    end
  end
end
