class PoliciesController < ApplicationController
  before_filter :clean_blank_parameters, only: [:create, :update]

  def index
    @policies = Policy.includes(:parent_policies).order(:name)
  end

  def new
    @policy = PolicyForm.new_with_defaults
    @policy.sub_policy = true if params[:sub_policy]
  end

  def create
    policy_form = PolicyForm.new(policy_params)

    if policy_form.save
      flash[:success] = "Successfully created a policy"
      redirect_to policies_path
    else
      flash[:danger] = "Could not create the policy : #{policy_form.error_message}"
      @policy = policy_form
      render :new
    end
  end

  def edit
    @policy = PolicyForm.from_existing(policy)
  end

  def update
    policy_form = PolicyForm.from_existing(policy)
    if policy_form.update(policy_params)
      flash[:success] = "Successfully updated the policy"

      redirect_to policies_path
    else
      flash[:danger] = "Could not update the policy: #{policy.errors.full_messages.to_sentence.downcase}"

      @policy = policy_form
      render :new
    end
  end

private

  def policy
    @policy ||= Policy.find(params[:id])
    @policy.fetch_links!
    @policy
  end

  def policy_params
    # We don't need to validate here because our forms will only forward
    # whitelisted attributes.
    params.require(:policy).permit!
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
