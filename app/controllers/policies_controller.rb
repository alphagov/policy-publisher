class PoliciesController < ApplicationController
  before_filter :clean_blank_parameters, only: [:create, :update]
  expose(:policy, attributes: :policy_params)
  expose(:policies)

  def index; end

  def new; end

  def create
    if policy.save
      flash[:notice] = "Successfully created a policy"

      redirect_to policies_path
    else
      flash[:alert] = "Could not create the policy : #{policy.errors.full_messages.to_sentence.downcase}"

      render :new
    end
  end

  def edit; end

  def update
    if policy.save
      flash[:notice] = "Successfully updated the policy"

      redirect_to policies_path
    else
      flash[:alert] = "Could not update the policy: #{policy.errors.full_messages.to_sentence.downcase}"

      render :new
    end
  end

private

  def policy_params
    params.require(:policy).permit(
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
      parent_policy_ids: [],
    )
  end

  # Rails includes a hidden field for selects on multi-selects so that a value
  # gets submitted even when nothing is selected. This results in a blank string
  # being included in the resulting parameter array. We clean this out to prevent
  # blank strings being stored.
  def clean_blank_parameters
    params[:policy][:organisation_content_ids].reject! {|id| id.blank? }
    params[:policy][:people_content_ids].reject! {|id| id.blank? }
  end
end
