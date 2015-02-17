class PolicyAreasController < ApplicationController
  expose(:policy_area, attributes: :policy_area_params)
  expose(:policy_areas)

  def index; end

  def new; end

  def create
    if policy_area.save
      flash[:notice] = "Successfully created a policy area"

      redirect_to policy_areas_path
    else
      flash[:alert] = "Could not create the policy area: #{policy_area.errors.full_messages.to_sentence.downcase}"

      render :new
    end
  end

  def edit; end

  def update
    if policy_area.save
      flash[:notice] = "Successfully updated the policy area"

      redirect_to policy_areas_path
    else
      flash[:alert] = "Could not update the policy area: #{policy_area.errors.full_messages.to_sentence.downcase}"

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
