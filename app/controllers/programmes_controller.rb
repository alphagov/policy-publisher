class ProgrammesController < ApplicationController
  before_filter :clean_blank_parameters, only: [:create, :update]
  expose(:programme, attributes: :programme_params)
  expose(:programmes)

  def index; end

  def new; end

  def create
    if programme.save
      flash[:notice] = "Successfully created a programme"

      redirect_to programmes_path
    else
      flash[:alert] = "Could not create the programme: #{programme.errors.full_messages.to_sentence.downcase}"

      render :new
    end
  end

  def edit; end

  def update
    if programme.save
      flash[:notice] = "Successfully updated the programme"

      redirect_to programmes_path
    else
      flash[:alert] = "Could not update the programme: #{programme.errors.full_messages.to_sentence.downcase}"

      render :new
    end
  end

  private

  def programme_params
    params.require(:programme).permit(
      :name,
      :description,
      policy_area_ids: [],
      organisation_content_ids: [],
      people_content_ids: [],
    )
  end

  # Rails includes a hidden field for selects on multi-selects so that a value
  # gets submitted even when nothing is selected. This results in a blank string
  # being included in the resulting parameter array. We clean this out to prevent
  # blank strings being stored.
  def clean_blank_parameters
    params[:programme][:organisation_content_ids].reject! {|id| id.blank? }
    params[:programme][:people_content_ids].reject! {|id| id.blank? }
  end
end
