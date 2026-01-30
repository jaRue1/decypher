class ObjectivesController < ApplicationController
  before_action :set_mission
  before_action :set_objective, only: [:update, :destroy, :toggle, :start]

  def create
    @objective = @mission.objectives.build(objective_params)
    @objective.status = "pending"

    if @objective.save
      redirect_to @mission, notice: "Objective added."
    else
      redirect_to @mission, alert: "Failed to add objective."
    end
  end

  def update
    if @objective.update(objective_params)
      respond_to do |format|
        format.html { redirect_to @mission, notice: "Objective updated." }
        format.turbo_stream
      end
    else
      redirect_to @mission, alert: "Failed to update objective."
    end
  end

  def destroy
    if @mission.status == "standby"
      @objective.destroy
      redirect_to @mission, notice: "Objective removed."
    else
      redirect_to @mission, alert: "Cannot remove objectives from an active mission."
    end
  end

  # POST /missions/:mission_id/objectives/:id/start
  def start
    if @mission.status != "active"
      redirect_to @mission, alert: "Mission must be active to start objectives."
      return
    end

    if @objective.start!
      redirect_to @mission, notice: "Objective in progress."
    else
      redirect_to @mission, alert: "Cannot start this objective."
    end
  end

  # POST /missions/:mission_id/objectives/:id/toggle
  def toggle
    if !%w[active completed].include?(@mission.status)
      redirect_to @mission, alert: "Mission must be active to update objectives."
      return
    end

    # Cycle through: pending → active → completed → active
    if @objective.pending?
      if @objective.start!
        redirect_to @mission, notice: "Objective started."
      else
        redirect_to @mission, alert: "Failed to start objective."
      end
    elsif @objective.status == "active"
      if @objective.complete!
        if @mission.reload.status == "completed"
          redirect_to @mission, notice: "Objective completed! Mission accomplished!"
        else
          redirect_to @mission, notice: "Objective completed. +#{@objective.xp_reward} XP"
        end
      else
        redirect_to @mission, alert: "Failed to complete objective."
      end
    elsif @objective.completed?
      # Uncomplete - move back to active
      if @objective.uncomplete!
        redirect_to @mission, notice: "Objective marked as in progress."
      else
        redirect_to @mission, alert: "Failed to update objective."
      end
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
    params.require(:objective).permit(:description, :difficulty, :skill_name, :position)
  end
end
