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
  def update_profile
    if @user.user_profile.update(user_profile_params)
      render json: { status: 200, profile: @user.user_profile }, status: 200
    else
      render json: { error: 'Failed to update profile' }, status: 422
    end
  end
  private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :date_of_birth, :profile_picture)
  end
  def user_profile_params
    params.require(:user_profile).permit(:first_name, :last_name, :date_of_birth, :profile_picture)
  end
  def validate_profile_params
    render json: { error: 'Invalid profile parameters' }, status: 422 unless params[:profile].present? || params[:user_profile].present?
    render json: { error: 'The first name is required.' }, status: 422 if params[:profile][:first_name].blank? || params[:user_profile][:first_name].blank?
    render json: { error: 'The last name is required.' }, status: 422 if params[:profile][:last_name].blank? || params[:user_profile][:last_name].blank?
    begin
      Date.parse(params[:profile][:date_of_birth]) if params[:profile].present?
      Date.parse(params[:user_profile][:date_of_birth]) if params[:user_profile].present?
    rescue ArgumentError
      render json: { error: 'The date of birth is not in valid format.' }, status: 422
    end
  end
  def set_user
    @user = User.find(params[:id])
    render json: { error: 'User not found' }, status: 404 unless @user
  end
  def authorize
    render json: { error: 'Unauthorized' }, status: 401 unless @user == current_user
  end
end
