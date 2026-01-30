class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_domains
  has_many :domains, through: :user_domains
  has_many :missions
  has_many :skills
  has_many :goals
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
