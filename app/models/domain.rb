class Domain < ApplicationRecord
  has_many :user_domains
  has_many :users, through: :user_domains
  has_many :missions
  has_many :skills
  has_many :goals
  scope :ordered, -> { order(:position) }
end
