class LocalExperiencesController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  def destroy
    local_experience = LocalExperience.find_by(id: params[:id])
    if local_experience
      local_experience.destroy
      render json: { message: 'Local experience deleted successfully' }
    else
      render json: { error: 'Local experience not found' }, status: 404
    end
  end
end
