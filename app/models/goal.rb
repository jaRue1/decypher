# frozen_string_literal: true

class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :domain, optional: true

  STATUSES = %w[active completed archived].freeze
  PRIORITIES = (1..5).to_a.freeze

  validates :content, presence: true
  validates :status, inclusion: { in: STATUSES }, allow_nil: true
  validates :priority, inclusion: { in: PRIORITIES }, allow_nil: true

  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :for_domain, ->(domain) { where(domain: domain) }

  # Complete the goal
  def complete!
    update!(status: 'completed')
  end

  # Archive the goal
  def archive!
    update!(status: 'archived')
  end

end
