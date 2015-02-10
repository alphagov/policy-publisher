class PoliciesController < ApplicationController
  expose(:policy, attributes: :policy_params)
  expose(:policies)

  def index; end

  def new; end

  def create
    if policy.save
      redirect_to policies_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if policy.save
      redirect_to policies_path
    else
      render :new
    end
  end

private

  def policy_params
    params.require(:policy).permit(
      :name,
      :description
    )
  end
end
