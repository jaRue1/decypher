class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_domains, dependent: :destroy
  has_many :domains, through: :user_domains
  has_many :missions, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :achievements, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Calculate power level (sum of all domain levels)
  def power_level
    user_domains.sum(:level)
  end

  # Add XP and update total
  def add_xp(amount)
    increment!(:total_xp, amount)
  end
end
