class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :domain, optional: true

  validates :content, presence: true

  scope :active, -> { where(status: "active") }
  scope :for_domain, ->(domain) { where(domain: domain) }
end
