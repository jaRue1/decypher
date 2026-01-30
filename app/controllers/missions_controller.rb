class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy]
  
  def index
    @missions = Current.user.missions.includes(:domain, :objectives)
  end

  def show
  end

  def new
    @mission = Current.user.missions.build
    @domains = Domain.ordered
  end

  def create
    @mission = Current.user.missions.build(mission_params)
    @mission.status = "active"

    if @mission.save
      redirect_to @mission, notice: "Mission created."
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

  private

    def set_mission
      @mission = Current.user.missions.find(params[:id])
    end

    def mission_params
      params.require(:mission).permit(:title, :description, :domain_id, :target_level)
    end

end
