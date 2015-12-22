class PoliciesController < ApplicationController
  before_filter :clean_blank_parameters, only: [:create, :update]

  def index
    @policies = Policy.includes(:parent_policies).order(:name)
  end

  def new
    @policy = Policy.new
    @policy.sub_policy = true if params[:sub_policy]
  end

  def create
    policy = Policy.new(policy_params)
    if policy.save
      Publisher.new(policy).publish!
      flash[:success] = "Successfully created a policy"

      redirect_to policies_path
    else
      flash[:danger] = "Could not create the policy : #{policy.errors.full_messages.to_sentence.downcase}"

      @policy = policy
      render :new
    end
  end

  def edit
    @policy = Policy.find(params[:id])
  end

  def update
    policy = Policy.find(params[:id])
    if policy.update_attributes(policy_params)
      Publisher.new(policy).publish!
      flash[:success] = "Successfully updated the policy"

      redirect_to policies_path
    else
      flash[:danger] = "Could not update the policy: #{policy.errors.full_messages.to_sentence.downcase}"

      @policy = policy
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
      :sub_policy,
      organisation_content_ids: [],
      people_content_ids: [],
      working_group_content_ids: [],
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
    params[:policy][:working_group_content_ids].reject! {|id| id.blank? }
  end
end
