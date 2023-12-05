class Api::LocalExperiencesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :delete_local_experience]
  before_action :authorize_user!, only: [:destroy, :delete_local_experience]
  def create
    local_experience = LocalExperience.new(local_experience_params)
    if local_experience.save
      render json: { status: 200, message: "Local experience was successfully created.", local_experience: local_experience }, status: 200
    else
      render json: { error: local_experience.errors.full_messages }, status: 422
    end
  end
  def update
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
    validator = LocalExperienceValidator.new(local_experience_params)
    unless validator.valid?
      render json: { error: validator.errors.full_messages }, status: 422
      return
    end
    begin
      local_experience.update(local_experience_params)
      render json: { status: 200, message: "The local experience was successfully updated.", local_experience: local_experience }, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  def delete_local_experience
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
      local_experience.image.purge
      local_experience.destroy
      render json: { status: 200, message: "The local experience was successfully deleted." }, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  private
  def local_experience_params
    params.require(:local_experience).permit(:title, :description, :location, :price, :image, :status)
  end
  def authorize_user!
    unless current_user.admin?
      render json: { error: "You do not have permission to perform this action." }, status: 403
    end
  end
end
