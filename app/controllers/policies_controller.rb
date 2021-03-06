class PoliciesController < ApplicationController
  before_action :clean_blank_parameters, only: [:create, :update]

  def index
    @policies = Policy.includes(:parent_policies).order(:name)
  end

  def new
    @policy_form = PolicyForm.new
    @policy_form.sub_policy = true if params[:sub_policy]
  end

  def create
    policy_form = PolicyForm.new(policy_params)

    if policy_form.save
      flash[:success] = "Successfully created a policy"
      redirect_to policies_path
    else
      flash[:danger] = "Could not create the policy : #{policy_form.error_messages}"
      @policy_form = policy_form
      render :new
    end
  end

  def edit
    @policy_form = PolicyForm.from_existing(policy)
  end

  def update
    policy_form = PolicyForm.from_existing(policy)
    if policy_form.update(policy_params)
      flash[:success] = "Successfully updated the policy"

      redirect_to policies_path
    else
      flash[:danger] = "Could not update the policy: #{policy_form.error_messages}"

      @policy_form = policy_form
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
    params.require(:policy).permit(
      :description,
      :england_policy_url,
      :england,
      :name,
      :northern_ireland_policy_url,
      :northern_ireland,
      :scotland_policy_url,
      :scotland,
      :sub_policy,
      :wales_policy_url,
      :wales,
      lead_organisation_content_ids: [],
      parent_policy_ids: [],
      people_content_ids: [],
      supporting_organisation_content_ids: [],
      working_group_content_ids: [],
    )
  end

  # Rails includes a hidden field for selects on multi-selects so that a value
  # gets submitted even when nothing is selected. This results in a blank string
  # being included in the resulting parameter array. We clean this out to prevent
  # blank strings being stored.
  def clean_blank_parameters
    params[:policy][:lead_organisation_content_ids].reject!(&:blank?)
    params[:policy][:supporting_organisation_content_ids].reject!(&:blank?)
    params[:policy][:people_content_ids].reject!(&:blank?)
    params[:policy][:working_group_content_ids].reject!(&:blank?)
  end
end
