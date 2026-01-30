class HabitLog < ApplicationRecord
  belongs_to :habit

  validates :date, presence: true
  validates :habit_id, uniqueness: { scope: :date }

  scope :completed, -> { where(completed: true) }
  scope :for_date, ->(date) { where(date: date) }
  scope :for_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }
end
