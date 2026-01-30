class ObjectivesController < ApplicationController
  before_action :set_mission
  before_action :set_objective, only: [:update, :destroy]

  def create
    @objective = @mission.objectives.build(objective_params)

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
    @objective.destroy
    redirect_to @mission, notice: "Objective removed."
  end

  private

  def set_mission
    @mission = Current.user.missions.find(params[:mission_id])
  end

  def set_objective
    @objective = @mission.objectives.find(params[:id])
  end

  def objective_params
    params.require(:objective).permit(:description, :status, :completed_at, :position)
  end
end
