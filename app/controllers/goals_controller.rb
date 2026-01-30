class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  def index
    @goals = Current.user.goals.includes(:domain)
  end

  def show
  end

  def new
    @goal = Current.user.goals.build
    @goal.domain_id = params[:domain_id] if params[:domain_id]
    @domains = Domain.ordered
  end

  def create
    @goal = Current.user.goals.build(goal_params)
    @goal.status = "active"

    if @goal.save
      redirect_to goals_path, notice: "Goal created."
    else
      @domains = Domain.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @domains = Domain.ordered
  end

  def update
    if @goal.update(goal_params)
      redirect_to goals_path, notice: "Goal updated."
    else
      @domains = Domain.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    redirect_to goals_path, notice: "Goal deleted."
  end

  private

  def set_goal
    @goal = Current.user.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:content, :domain_id, :goal_type, :timeframe)
  end
end
