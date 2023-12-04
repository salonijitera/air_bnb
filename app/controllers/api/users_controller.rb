class Api::UsersController < ApplicationController
  before_action :authorize, only: [:update, :create_profile, :update_profile]
  before_action :set_user, only: [:update, :create_profile, :update_profile]
  before_action :validate_params, only: [:update]
  before_action :validate_profile_params, only: [:create_profile, :update_profile]
  def register
    # ... existing code ...
  end
  def create_profile
    begin
      profile = UserService.create_profile(@user, profile_params)
      render json: { status: 200, profile: profile }, status: 200
    rescue Exception => e
      render json: { error: 'Failed to create profile' }, status: 500
    end
  end
  private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :date_of_birth, :profile_picture)
  end
  def validate_profile_params
    params.require(:profile).permit(:first_name, :last_name, :date_of_birth, :profile_picture)
    render json: { error: 'Invalid profile parameters' }, status: 400 unless params[:profile].present?
  end
  def set_user
    @user = User.find(params[:id])
    render json: { error: 'User not found' }, status: 404 unless @user
  end
  def authorize
    render json: { error: 'Unauthorized' }, status: 401 unless @user == current_user
  end
end
