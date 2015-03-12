class PolicyAreasController < ApplicationController
  before_filter :clean_blank_parameters, only: [:create, :update]
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
      :description,
      :england,
      :england_policy_url,
      :northern_ireland,
      :northern_ireland_policy_url,
      :scotland,
      :scotland_policy_url,
      :wales,
      :wales_policy_url,
      organisation_content_ids: [],
      people_content_ids: [],
    )
  end

  # Rails includes a hidden field for selects on multi-selects so that a value
  # gets submitted even when nothing is selected. This results in a blank string
  # being included in the resulting parameter array. We clean this out to prevent
  # blank strings being stored.
  def clean_blank_parameters
    params[:policy_area][:organisation_content_ids].reject! {|id| id.blank? }
    params[:policy_area][:people_content_ids].reject! {|id| id.blank? }
  end
end
