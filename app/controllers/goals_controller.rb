# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :set_goal, only: %i[show edit update destroy complete generate_missions]

  def index
    @goals = Current.user.goals.includes(:domain)
  end

  def show; end

  def new
    @goal = Current.user.goals.build
    @goal.domain_id = params[:domain_id] if params[:domain_id]
    @domains = Domain.ordered
  end

  def edit
    @domains = Domain.ordered
  end

  def create
    @goal = Current.user.goals.build(goal_params)
    @goal.status = "active"

    if @goal.save
      redirect_to goals_path, notice: "Goal created."
    else
      @domains = Domain.ordered
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @goal.update(goal_params)
      redirect_to goals_path, notice: "Goal updated."
    else
      @domains = Domain.ordered
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @goal.destroy
    redirect_to goals_path, notice: "Goal deleted."
  end

  def complete
    @goal.update(status: "completed")
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to goals_path, notice: "Goal completed!" }
    end
  end

  def generate_missions
    generator = Operator::MissionGenerator.new
    @missions = generator.generate_from_goal(@goal)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to goals_path, notice: "#{@missions.count} missions generated for this goal!" }
    end
  rescue Operator::Base::ApiError, Operator::MissionGenerator::GenerationError => e
    respond_to do |format|
      format.turbo_stream { render :generate_missions_error, locals: { error: e.message } }
      format.html { redirect_to goals_path, alert: "Mission generation failed: #{e.message}" }
    end
  end

  private

  def set_goal
    @goal = Current.user.goals.find(params[:id])
  end

  def goal_params
    params.expect(goal: %i[content domain_id goal_type timeframe priority context success_criteria current_blockers])
  end
end
