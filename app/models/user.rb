class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_domains, dependent: :destroy
  has_many :domains, through: :user_domains
  has_many :missions, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :habits, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Calculate power level (sum of all domain levels)
  def power_level
    user_domains.sum(:level)
  end

  # Add XP and update total
  def add_xp(amount)
    increment!(:total_xp, amount)
  end

  # Daily habit completion rate
  def daily_habit_completion_rate(date = Date.current)
    active_habits = habits.active
    return 0 if active_habits.empty?

    completed = HabitLog.joins(:habit)
                        .where(habits: { user_id: id, active: true })
                        .where(date: date, completed: true)
                        .count

    (completed.to_f / active_habits.count * 100).round(0)
  end

  # Monthly habit stats
  def monthly_habit_stats(date = Date.current)
    start_date = date.beginning_of_month
    end_date = [date.end_of_month, Date.current].min
    days_elapsed = (end_date - start_date).to_i + 1

    active_habits = habits.active
    total_possible = active_habits.count * days_elapsed

    total_completed = HabitLog.joins(:habit)
                              .where(habits: { user_id: id, active: true })
                              .where(date: start_date..end_date, completed: true)
                              .count

    {
      total_habits: active_habits.count,
      completed_count: total_completed,
      total_possible: total_possible,
      percentage: total_possible > 0 ? (total_completed.to_f / total_possible * 100).round(2) : 0
    }
  end
end
