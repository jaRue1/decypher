# frozen_string_literal: true

class DailyEntriesController < ApplicationController
  def index
    @date = if params[:year] && params[:month]
              Date.new(params[:year].to_i, params[:month].to_i, 1)
    elsif params[:date]
              params[:date].to_date
    else
              Date.current
    end

    # Don't allow future months
    @date = Date.current if @date > Date.current

    @month_start = @date.beginning_of_month
    @month_end = @date.end_of_month

    # Get all entries for the month
    @entries = Current.user.daily_entries
                           .where(date: @month_start..@month_end)
                           .index_by(&:date)

    # Build calendar grid (6 weeks to cover all possible month layouts)
    @calendar_start = @month_start.beginning_of_week(:sunday)
    @calendar_end = @calendar_start + 41.days # 6 weeks
    @calendar_dates = (@calendar_start..@calendar_end).to_a
  end

  def show
    @date = params[:date]&.to_date || Date.current
    @entry = Current.user.daily_entries.find_or_initialize_by(date: @date)

    # Habit data for the day
    @habits = Current.user.habits.active.ordered
    @habit_logs = HabitLog.joins(:habit)
                          .where(habits: { user_id: Current.user.id })
                          .where(date: @date)
                          .index_by(&:habit_id)

    # Calculate completion stats
    @habits_completed = @habits.count { |h| @habit_logs[h.id]&.completed }
    @habits_percentage = @habits.any? ? (@habits_completed.to_f / @habits.count * 100).round(0) : 0

    # Week navigation
    @week_dates = ((@date.beginning_of_week(:sunday))..(@date.beginning_of_week(:sunday) + 6)).to_a

    # Prepare trend chart data for the current week (Monday to Sunday)
    week_start = @date.beginning_of_week(:monday)
    week_end = week_start + 6.days
    @trend_dates = (week_start..week_end).to_a

    # Fetch entries for the week
    @recent_entries = Current.user.daily_entries
                                  .where(date: week_start..week_end)
                                  .order(:date)

    @trend_labels = @trend_dates.map { |d| d.strftime("%a") }
    @trend_mood_data = @trend_dates.map do |date|
      entry = @recent_entries.find { |e| e.date == date }
      entry&.mood_score
    end
    @trend_motivation_data = @trend_dates.map do |date|
      entry = @recent_entries.find { |e| e.date == date }
      entry&.motivation_score
    end
  end

  def update
    @date = params[:date]&.to_date || Date.current
    @entry = Current.user.daily_entries.find_or_initialize_by(date: @date)

    if @entry.update(daily_entry_params)
      # Recalculate trend data for turbo_stream response
      load_trend_data

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to daily_entry_path(date: @date), notice: "Entry saved." }
      end
    else
      # Reload data for show view
      @habits = Current.user.habits.active.ordered
      @habit_logs = HabitLog.joins(:habit)
                            .where(habits: { user_id: Current.user.id })
                            .where(date: @date)
                            .index_by(&:habit_id)
      @habits_completed = @habits.count { |h| @habit_logs[h.id]&.completed }
      @habits_percentage = @habits.any? ? (@habits_completed.to_f / @habits.count * 100).round(0) : 0
      @week_dates = ((@date.beginning_of_week(:sunday))..(@date.beginning_of_week(:sunday) + 6)).to_a
      @recent_entries = Current.user.daily_entries.where(date: (@date - 6.days)..@date).order(:date)

      render :show, status: :unprocessable_entity
    end
  end

  private

  def load_trend_data
    week_start = @date.beginning_of_week(:monday)
    week_end = week_start + 6.days
    @trend_dates = (week_start..week_end).to_a

    @recent_entries = Current.user.daily_entries
                                  .where(date: week_start..week_end)
                                  .order(:date)

    @trend_labels = @trend_dates.map { |d| d.strftime("%a") }
    @trend_mood_data = @trend_dates.map do |date|
      entry = @recent_entries.find { |e| e.date == date }
      entry&.mood_score
    end
    @trend_motivation_data = @trend_dates.map do |date|
      entry = @recent_entries.find { |e| e.date == date }
      entry&.motivation_score
    end
  end

  def daily_entry_params
    params.expect(daily_entry: %i[mood_score motivation_score wins improvements notes])
  end
end
