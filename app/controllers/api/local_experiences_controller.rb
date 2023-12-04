class Api::LocalExperiencesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :authorize_user!, only: [:destroy]
  def create
    validator = LocalExperienceValidator.new(local_experience_params)
    unless validator.valid?
      render json: { error: validator.errors.full_messages }, status: 422
      return
    end
    location = Location.find_by(name: local_experience_params[:location])
    unless location
      render json: { error: "Location not found!" }, status: 422
      return
    end
    begin
      local_experience = LocalExperience.create!(local_experience_params.merge(location_id: location.id))
      render json: { status: 200, message: "Local experience was successfully created.", localExperience: local_experience }, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  def destroy
    id = params[:id].to_i
    unless id > 0
      render json: { error: "Wrong format." }, status: 422
      return
    end
    local_experience = LocalExperience.find_by(id: id)
    unless local_experience
      render json: { error: "This local experience is not found." }, status: 404
      return
    end
    begin
      local_experience.destroy
      render json: { status: 200, message: "The local experience was successfully deleted." }, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  def show
    begin
      local_experience = LocalExperience.find(params[:id])
      render json: local_experience, status: 200
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Local experience not found!" }, status: 404
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  private
  def local_experience_params
    params.require(:local_experience).permit(:title, :description, :location, :price, :date, :image)
  end
  def authorize_user!
    unless current_user.admin?
      render json: { error: "You do not have permission to perform this action." }, status: 403
    end
  end
end
