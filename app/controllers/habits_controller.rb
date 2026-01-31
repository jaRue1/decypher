# frozen_string_literal: true

class HabitsController < ApplicationController
  before_action :set_habit, only: %i[show edit update destroy toggle archive]

  def index
    @date = params[:date]&.to_date || Date.current
    @habits = Current.user.habits.active.ordered.includes(:habit_logs)
    @month_dates = @date.all_month.to_a
    @stats = Current.user.monthly_habit_stats(@date)

    # Preload habit logs for the month for performance
    @habit_logs = HabitLog.joins(:habit)
                          .where(habits: { user_id: Current.user.id })
                          .where(date: @date.all_month)
                          .index_by { |log| [ log.habit_id, log.date ] }

    # Prepare weekly progress data (current week: Sun-Sat)
    @week_start = Date.current.beginning_of_week(:sunday)
    @week_dates = (@week_start..(@week_start + 6)).to_a
    @week_labels = @week_dates.map { |d| d.strftime("%a") }

    # For bar chart: count of completed habits per day
    @week_completed = @week_dates.map do |date|
      next 0 if date > Date.current
      @habits.count { |h| @habit_logs[[ h.id, date ]]&.completed }
    end

    # For donut: total completed vs total possible this week
    days_elapsed = [ @week_dates.count { |d| d <= Date.current }, 1 ].max
    @week_total_possible = @habits.count * days_elapsed
    @week_total_completed = @week_dates.select { |d| d <= Date.current }.sum do |date|
      @habits.count { |h| @habit_logs[[ h.id, date ]]&.completed }
    end
    @week_percentage = @week_total_possible.positive? ? (@week_total_completed.to_f / @week_total_possible * 100).round(0) : 0
  end

  def show
    redirect_to edit_habit_path(@habit)
  end

  def new
    @habit = Current.user.habits.build
    @domains = Domain.ordered
  end

  def edit
    @domains = Domain.ordered
  end

  def create
    @habit = Current.user.habits.build(habit_params)

    if @habit.save
      redirect_to habits_path, notice: "Habit created."
    else
      @domains = Domain.ordered
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: "Habit updated."
    else
      @domains = Domain.ordered
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: "Habit deleted."
  end

  def toggle
    date = params[:date].to_date
    @log = @habit.toggle_completion!(date)
    @date = date

    # Reload all stats for turbo_stream updates
    load_habits_data

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { completed: @log.completed } }
    end
  end

  def archive
    @habit.update(active: false)
    redirect_to habits_path, notice: "Habit archived. Your history is preserved."
  end

  private

  def load_habits_data
    @habits = Current.user.habits.active.ordered.includes(:habit_logs)
    @stats = Current.user.monthly_habit_stats(@date)

    # Preload habit logs for the month
    @habit_logs = HabitLog.joins(:habit)
                          .where(habits: { user_id: Current.user.id })
                          .where(date: @date.all_month)
                          .index_by { |log| [ log.habit_id, log.date ] }

    # Weekly progress data
    @week_start = Date.current.beginning_of_week(:sunday)
    @week_dates = (@week_start..(@week_start + 6)).to_a
    @week_labels = @week_dates.map { |d| d.strftime("%a") }

    @week_completed = @week_dates.map do |date|
      next 0 if date > Date.current
      @habits.count { |h| @habit_logs[[ h.id, date ]]&.completed }
    end

    days_elapsed = [ @week_dates.count { |d| d <= Date.current }, 1 ].max
    @week_total_possible = @habits.count * days_elapsed
    @week_total_completed = @week_dates.select { |d| d <= Date.current }.sum do |date|
      @habits.count { |h| @habit_logs[[ h.id, date ]]&.completed }
    end
    @week_percentage = @week_total_possible.positive? ? (@week_total_completed.to_f / @week_total_possible * 100).round(0) : 0

    # Today's progress
    @today_completed = @habits.count { |h| @habit_logs[[ h.id, Date.current ]]&.completed }
    @today_percentage = @habits.any? ? (@today_completed.to_f / @habits.count * 100).round(0) : 0
  end

  def set_habit
    @habit = Current.user.habits.find(params[:id])
  end

  def habit_params
    params.expect(habit: %i[name icon color domain_id target_days_per_week target_days_per_month
                            active])
  end
end
