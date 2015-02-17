class ProgrammesController < ApplicationController
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
      :description
    )
  end
end
