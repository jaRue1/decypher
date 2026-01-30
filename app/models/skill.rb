# frozen_string_literal: true

class Skill < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  belongs_to :objective, optional: true

  validates :name, presence: true

  scope :for_domain, ->(domain) { where(domain: domain) }
  scope :recent, -> { order(acquired_at: :desc) }
end
