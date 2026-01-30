# frozen_string_literal: true

class Mission < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  has_many :objectives, dependent: :destroy
  has_one :badge, dependent: :destroy

  STATUSES = %w[standby active completed aborted].freeze
  GRADES = %w[D C B A].freeze

  validates :status, inclusion: { in: STATUSES }, allow_nil: true
  validates :grade, inclusion: { in: GRADES }, allow_nil: true

  scope :standby, -> { where(status: 'standby') }
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :aborted, -> { where(status: 'aborted') }
  scope :for_domain, ->(domain) { where(domain: domain) }

  # Commence (start or resume) the mission
  def commence!
    return false unless %w[standby aborted].include?(status)

    # Only set started_at on first commence
    if started_at.nil?
      update!(status: 'active', started_at: Time.current)
    else
      update!(status: 'active')
    end
  end

  # Abort the mission
  def abort!
    return false unless status == 'active'

    update!(status: 'aborted')
  end

  # Complete the mission
  def complete!
    return false unless status == 'active'
    return false unless all_objectives_completed?

    transaction do
      update!(status: 'completed', completed_at: Time.current)

      # Award XP to user domain
      user_domain = user.user_domains.find_by(domain: domain)
      user_domain&.add_xp(total_xp)

      # Record achievement (only if not already recorded)
      user.achievements.find_or_create_by!(
        achievement_type: 'mission_completed',
        achievable: self
      ) do |achievement|
        achievement.metadata = { title: title, grade: grade, xp_earned: total_xp }
        achievement.achieved_at = Time.current
      end

      # Advance grade in domain
      user_domain&.advance_grade!

      # Check for level up
      user_domain&.level_up! if user_domain&.can_level_up?
    end

    true
  end

  # Check if all objectives are completed
  def all_objectives_completed?
    objectives.any? && objectives.all?(&:completed?)
  end

  # Calculate total XP for this mission
  def total_xp
    objectives.sum(:xp_reward)
  end

  # Calculate completion percentage
  def completion_percentage
    return 0 if objectives.empty?

    ((objectives.completed.count.to_f / objectives.count) * 100).round
  end

  # Time spent on mission
  def duration
    return nil unless started_at

    end_time = completed_at || Time.current
    end_time - started_at
  end
end
