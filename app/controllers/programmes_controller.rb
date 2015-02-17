class ProgrammesController < ApplicationController
  expose(:programme, attributes: :programme_params)
  expose(:programmes)

  def index; end

  def new; end

  def create
    if programme.save
      redirect_to programmes_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if programme.save
      redirect_to programmes_path
    else
      render :new
    end
  end

  private

  def programme_params
    params.require(:programme).permit(
      :name,
      :description,
      {policy_area_ids: []}
    )
  end
end
