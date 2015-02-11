class PolicyAreasController < ApplicationController
  expose(:policy_area, attributes: :policy_area_params)
  expose(:policy_areas)

  def index; end

  def new; end

  def create
    if policy_area.save
      redirect_to policy_areas_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if policy_area.save
      redirect_to policy_areas_path
    else
      render :new
    end
  end

private

  def policy_area_params
    params.require(:policy_area).permit(
      :name,
      :description
    )
  end
end
