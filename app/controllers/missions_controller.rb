class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy, :commence, :abort_mission]

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

  def create
    @mission = Current.user.missions.build(mission_params)
    @mission.status = "standby"

    if @mission.save
      redirect_to @mission, notice: "Mission created. Ready to commence."
    else
      @domains = Domain.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @domains = Domain.ordered
  end

  def update
    if @mission.update(mission_params)
      redirect_to @mission, notice: "Mission updated."
    else
      @domains = Domain.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mission.destroy
    redirect_to missions_path, notice: "Mission deleted."
  end

  # POST /missions/:id/commence
  def commence
    if @mission.domain.has_active_mission?(Current.user) && @mission.status != "active"
      redirect_to @mission, alert: "You already have an active mission in #{@mission.domain.name}. Complete or abort it first."
      return
    end

    resuming = @mission.status == "aborted"

    if @mission.commence!
      if resuming
        redirect_to @mission, notice: "Mission resumed. Welcome back, operator."
      else
        redirect_to @mission, notice: "Mission commenced. Good luck, operator."
      end
    else
      redirect_to @mission, alert: "Cannot commence this mission."
    end
  end

  # POST /missions/:id/abort
  def abort_mission
    if @mission.abort!
      redirect_to missions_path, notice: "Mission aborted."
    else
      redirect_to @mission, alert: "Cannot abort this mission."
    end
  end

  private

  def set_mission
    @mission = Current.user.missions.find(params[:id])
  end

  def mission_params
    params.require(:mission).permit(:title, :description, :domain_id, :target_level, :grade)
  end
end
