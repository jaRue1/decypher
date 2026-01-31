# frozen_string_literal: true

class ObjectivesController < ApplicationController
  before_action :set_mission
  before_action :set_objective, only: %i[edit update destroy toggle start]

  def create
    @objective = @mission.objectives.build(objective_params)
    @objective.status = 'pending'

    if @objective.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @mission, notice: 'Objective added.' }
      end
    else
      redirect_to @mission, alert: 'Failed to add objective.'
    end
  end

  def edit
    unless %w[standby active].include?(@mission.status)
      redirect_to @mission, alert: 'Cannot edit objectives on a completed mission.'
      return
    end

    respond_to do |format|
      format.html { redirect_to @mission }
      format.turbo_stream
    end
  end

  def update
    if @objective.update(objective_params)
      respond_to do |format|
        format.html { redirect_to @mission, notice: 'Objective updated.' }
        format.turbo_stream
      end
    else
      redirect_to @mission, alert: 'Failed to update objective.'
    end
  end

  def destroy
    unless %w[standby active].include?(@mission.status)
      redirect_to @mission, alert: 'Cannot remove objectives from a completed mission.'
      return
    end

    @objective.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @mission, notice: 'Objective removed.' }
    end
  end

  # POST /missions/:mission_id/objectives/:id/start
  def start
    if @mission.status != 'active'
      redirect_to @mission, alert: 'Mission must be active to start objectives.'
      return
    end

    if @objective.start!
      redirect_to @mission, notice: 'Objective in progress.'
    else
      redirect_to @mission, alert: 'Cannot start this objective.'
    end
  end

  # POST /missions/:mission_id/objectives/:id/toggle
  def toggle
    unless %w[active completed].include?(@mission.status)
      redirect_to @mission, alert: 'Mission must be active to update objectives.'
      return
    end

    # Cycle through: pending → active → completed → active
    success = false
    notice = nil

    if @objective.pending?
      if @objective.start!
        success = true
        notice = 'Objective started.'
      end
    elsif @objective.status == 'active'
      if @objective.complete!
        success = true
        @mission.reload
        notice = @mission.status == 'completed' ? 'Objective completed! Mission accomplished!' : "Objective completed. +#{@objective.xp_reward} XP"
      end
    elsif @objective.completed?
      if @objective.uncomplete!
        success = true
        notice = 'Objective marked as in progress.'
      end
    end

    if success
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @mission, notice: notice }
      end
    else
      redirect_to @mission, alert: 'Failed to update objective.'
    end
  end

  private

  def set_mission
    @mission = Current.user.missions.find(params[:mission_id])
  end

  def set_objective
    @objective = @mission.objectives.find(params[:id])
  end

  def objective_params
    params.expect(objective: %i[description difficulty skill_name position])
  end
end
