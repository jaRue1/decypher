# frozen_string_literal: true

class Objective < ApplicationRecord
  belongs_to :mission
  has_many :skills, dependent: :destroy

  STATUSES = %w[pending active completed].freeze
  DIFFICULTIES = (1..4).to_a.freeze
  XP_BY_DIFFICULTY = { 1 => 25, 2 => 50, 3 => 75, 4 => 100 }.freeze

  validates :status, inclusion: { in: STATUSES }, allow_nil: true
  validates :difficulty, inclusion: { in: DIFFICULTIES }

  before_save :set_xp_reward

  scope :pending, -> { where(status: 'pending').or(where(status: nil)) }
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }

  # Start working on the objective
  def start!
    return false if completed?

    update!(status: 'active', started_at: Time.current)
  end

  # Complete the objective
  def complete!
    return false if completed?

    transaction do
      update!(status: 'completed', completed_at: Time.current)

      # Create skill for the user
      if skill_name.present?
        skills.create!(
          user: mission.user,
          domain: mission.domain,
          name: skill_name,
          xp_value: xp_reward,
          acquired_at: Time.current
        )
      end

      # Record achievement (only if not already recorded)
      mission.user.achievements.find_or_create_by!(
        achievement_type: 'objective_completed',
        achievable: self
      ) do |achievement|
        achievement.metadata = { description: description, xp_earned: xp_reward, skill: skill_name }
        achievement.achieved_at = Time.current
      end

      # Check if mission is now complete
      mission.complete! if mission.all_objectives_completed?
    end

    true
  end

  # Uncomplete the objective (move back to active)
  def uncomplete!
    return false unless completed?

    transaction do
      update!(status: 'active', completed_at: nil)

      # If mission was completed, reactivate it
      mission.update!(status: 'active', completed_at: nil) if mission.status == 'completed'
    end

    true
  end

  def completed?
    status == 'completed' || completed_at.present?
  end

  def pending?
    status.nil? || status == 'pending'
  end

  # Time spent on objective
  def duration
    return nil unless started_at

    end_time = completed_at || Time.current
    end_time - started_at
  end

  private

  def set_xp_reward
    self.xp_reward = XP_BY_DIFFICULTY[difficulty] || 25
  end
end
