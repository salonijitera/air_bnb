class LocalExperiencesController < ApplicationController
  before_action :find_local_experience, only: [:update, :destroy]
  before_action :authenticate_user!, only: [:destroy]
  def update
    begin
      if @local_experience.update(local_experience_params)
        render json: { status: 200, message: "Local experience was successfully updated." }, status: 200
      else
        render json: { error: @local_experience.errors.full_messages }, status: 422
      end
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  def destroy
    if @local_experience
      @local_experience.destroy
      render json: { message: 'Local experience deleted successfully' }
    else
      render json: { error: 'Local experience not found' }, status: 404
    end
  end
  private
  def local_experience_params
    params.require(:local_experience).permit(:id, :title, :description, :location, :price, :date, :image)
  end
  def find_local_experience
    @local_experience = LocalExperience.find_by(id: params[:id])
    unless @local_experience
      render json: { error: "Local experience not found!" }, status: 404
    end
  end
end
