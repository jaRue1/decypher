# frozen_string_literal: true

class MissionsController < ApplicationController
  before_action :set_mission, only: %i[show edit update destroy commence abort_mission generate_next generate_habits]

  def index
    @missions = Current.user.missions.includes(:domain, :objectives).order(created_at: :desc)
  end

  def show
    @objectives = @mission.objectives.order(:position)
  end

  def new
    @mission = Current.user.missions.build(status: "standby")
    @domains = Domain.ordered
  end

  def edit
    @domains = Domain.ordered
  end

  def create
    @mission = Current.user.missions.build(mission_params)
    @mission.status = "standby"

    if @mission.save
      redirect_to @mission, notice: "Mission created. Ready to commence."
    else
      @domains = Domain.ordered
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @mission.update(mission_params)
      redirect_to @mission, notice: "Mission updated."
    else
      @domains = Domain.ordered
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @mission.destroy
    redirect_to missions_path, notice: "Mission deleted."
  end

  # POST /missions/:id/commence
  def commence
    if @mission.domain.has_active_mission?(Current.user) && @mission.status != "active"
      redirect_to @mission,
                  alert: "You already have an active mission in #{@mission.domain.name}. Complete or abort it first."
      return
    end

    resuming = @mission.status == "aborted"

    if @mission.commence!
      @objectives = @mission.objectives.order(:position)
      notice = resuming ? "Mission resumed. Welcome back, operator." : "Mission commenced. Good luck, operator."

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @mission, notice: notice }
      end
    else
      redirect_to @mission, alert: "Cannot commence this mission."
    end
  end

  # POST /missions/:id/abort
  def abort_mission
    if @mission.abort!
      @objectives = @mission.objectives.order(:position)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @mission, notice: "Mission aborted." }
      end
    else
      redirect_to @mission, alert: "Cannot abort this mission."
    end
  end

  # POST /missions/:id/generate_next
  def generate_next
    unless @mission.status == "completed"
      redirect_to @mission, alert: "Complete this mission first to generate the next one."
      return
    end

    generator = Operator::MissionGenerator.new
    @next_mission = generator.generate_next(@mission)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @next_mission, notice: "Next mission generated!" }
    end
  rescue Operator::Base::ApiError, Operator::MissionGenerator::GenerationError => e
    respond_to do |format|
      format.turbo_stream { render :generate_next_error, locals: { error: e.message } }
      format.html { redirect_to @mission, alert: "Mission generation failed: #{e.message}" }
    end
  end

  # POST /missions/:id/generate_habits
  def generate_habits
    generator = Operator::HabitGenerator.new
    @habits = generator.generate_for_mission(@mission)

    redirect_to @mission, notice: "#{@habits.count} habits generated to support this mission!"
  rescue Operator::Base::ApiError, Operator::HabitGenerator::GenerationError => e
    redirect_to @mission, alert: "Habit generation failed: #{e.message}"
  end

  private

  def set_mission
    @mission = Current.user.missions.find(params[:id])
  end

  def mission_params
    params.expect(mission: %i[title description domain_id target_level grade])
  end
end
