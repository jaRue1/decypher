# frozen_string_literal: true

class Habit < ApplicationRecord
  belongs_to :user
  belongs_to :domain, optional: true
  has_many :habit_logs, dependent: :destroy

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :created_at) }

  before_create :set_position

  def completion_rate_for_month(date = Date.current)
    start_date = date.beginning_of_month
    end_date = [date.end_of_month, Date.current].min
    days_in_range = (end_date - start_date).to_i + 1

    completed_count = habit_logs.where(date: start_date..end_date, completed: true).count
    return 0 if days_in_range.zero?

    (completed_count.to_f / days_in_range * 100).round(1)
  end

  def completed_days_for_month(date = Date.current)
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    habit_logs.where(date: start_date..end_date, completed: true).count
  end

  def completed_on?(date)
    habit_logs.exists?(date: date, completed: true)
  end

  def toggle_completion!(date)
    log = habit_logs.find_or_initialize_by(date: date)
    log.completed = !log.completed
    log.save!
    log
  end

  def current_streak
    streak = 0
    date = Date.current

    while habit_logs.exists?(date: date, completed: true)
      streak += 1
      date -= 1.day
    end

    streak
  end

  def longest_streak
    completed_dates = habit_logs.where(completed: true).order(:date).pluck(:date)
    return 0 if completed_dates.empty?

    max_streak = 1
    current = 1

    completed_dates.each_cons(2) do |prev_date, curr_date|
      if curr_date - prev_date == 1
        current += 1
        max_streak = [max_streak, current].max
      else
        current = 1
      end
    end

    max_streak
  end

  private

  def set_position
    self.position ||= (user.habits.maximum(:position) || 0) + 1
  end
end
