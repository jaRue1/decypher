class HabitsController < ApplicationController
  before_action :set_habit, only: [:show, :edit, :update, :destroy, :toggle]

  def show
    redirect_to edit_habit_path(@habit)
  end

  def index
    @date = params[:date]&.to_date || Date.current
    @habits = Current.user.habits.active.ordered.includes(:habit_logs)
    @month_dates = (@date.beginning_of_month..@date.end_of_month).to_a
    @stats = Current.user.monthly_habit_stats(@date)

    # Preload habit logs for the month for performance
    @habit_logs = HabitLog.joins(:habit)
                          .where(habits: { user_id: Current.user.id })
                          .where(date: @date.beginning_of_month..@date.end_of_month)
                          .index_by { |log| [log.habit_id, log.date] }
  end

  def new
    @habit = Current.user.habits.build
    @domains = Domain.ordered
  end

  def create
    @habit = Current.user.habits.build(habit_params)

    if @habit.save
      redirect_to habits_path, notice: "Habit created."
    else
      @domains = Domain.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @domains = Domain.ordered
  end

  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: "Habit updated."
    else
      @domains = Domain.ordered
      render :edit, status: :unprocessable_entity
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

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { completed: @log.completed } }
    end
  end

  private

  def set_habit
    @habit = Current.user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(:name, :icon, :color, :domain_id, :target_days_per_week, :target_days_per_month, :active)
  end
end
