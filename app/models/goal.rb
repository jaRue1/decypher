class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :domain, optional: true

  STATUSES = %w[active completed archived].freeze

  validates :content, presence: true
  validates :status, inclusion: { in: STATUSES }, allow_nil: true
  validate :one_active_per_domain, on: :create

  scope :active, -> { where(status: "active") }
  scope :completed, -> { where(status: "completed") }
  scope :for_domain, ->(domain) { where(domain: domain) }

  # Complete the goal
  def complete!
    update!(status: "completed")
  end

  # Archive the goal
  def archive!
    update!(status: "archived")
  end

  private

  # Ensure only one active goal per domain per user
  def one_active_per_domain
    return unless domain.present? && status == "active"

    existing = user.goals.active.for_domain(domain).where.not(id: id)
    if existing.exists?
      errors.add(:base, "You already have an active goal for this domain")
    end
  end
end
