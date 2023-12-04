class Api::LocalExperiencesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def create
    validator = WishListValidator.new(local_experience_params)
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
      render json: { status: 200, message: "Local experience was successfully created.", id: local_experience.id }, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  private
  def local_experience_params
    params.require(:local_experience).permit(:title, :description, :location, :price, :date, :image)
  end
end
