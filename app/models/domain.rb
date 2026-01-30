class Domain < ApplicationRecord
  has_many :user_domains, dependent: :destroy
  has_many :users, through: :user_domains
  has_many :missions, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :goals, dependent: :nullify
  has_many :badges, through: :missions

  scope :ordered, -> { order(:position) }

  # Get user's current level in this domain
  def level_for(user)
    user_domains.find_by(user: user)&.level || 1
  end

  # Get active mission for user in this domain
  def active_mission_for(user)
    missions.active.find_by(user: user)
  end

  # Check if user has active mission in this domain
  def has_active_mission?(user)
    active_mission_for(user).present?
  end
end
