class Api::UsersController < ApplicationController
  before_action :authorize, only: [:update, :create_profile, :update_profile]
  before_action :set_user, only: [:update, :create_profile, :update_profile]
  before_action :validate_params, only: [:update]
  before_action :validate_profile_params, only: [:create_profile, :update_profile]
  def update
    if @user.update(user_params)
      render json: { message: 'Profile updated successfully', user: @user }, status: 200
    else
      render json: { message: 'Failed to update profile', errors: @user.errors.full_messages }, status: 422
    end
  end
  def create_profile
    profile_params = params.require(:profile).permit(:first_name, :last_name, :date_of_birth, :profile_picture)
    result = UserService.create_profile(@user, profile_params)
    if result[:success]
      render json: { message: 'Profile created successfully', profile: result[:profile] }, status: 200
    else
      render json: { message: 'Failed to create profile', errors: result[:errors] }, status: 422
    end
  end
  def update_profile
    if @user.user_profile.update(profile_params)
      render json: { message: 'Profile updated successfully', user: @user }, status: 200
    else
      render json: { message: 'Failed to update profile', errors: @user.user_profile.errors.full_messages }, status: 422
    end
  end
  private
  def set_user
    @user = User.find_by_id(params[:id] || params[:user_id])
    if @user.nil?
      render json: { error: 'User not found' }, status: 404
    elsif current_user != @user
      render json: { error: 'You are not authorized to perform this action' }, status: 403
    end
  end
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :date_of_birth, :profile_picture)
  end
  def validate_profile_params
    profile_params = params[:profile] || params[:user]
    return render json: { message: 'First name is required.' }, status: 422 if profile_params[:first_name].blank?
    return render json: { message: 'Last name is required.' }, status: 422 if profile_params[:last_name].blank?
    return render json: { message: 'Date of birth is required.' }, status: 422 if profile_params[:date_of_birth].blank?
    return render json: { message: 'Profile picture is required.' }, status: 422 if profile_params[:profile_picture].blank?
    begin
      Date.parse(profile_params[:date_of_birth])
    rescue ArgumentError
      return render json: { message: 'Date of birth is not in valid format.' }, status: 422
    end
  end
  def authorize
    return render json: { message: 'User is not authenticated' }, status: 401 unless current_user
  end
  def validate_params
    return render json: { message: 'Wrong format' }, status: 422 unless params[:id].is_a?(Integer)
    return render json: { message: 'The name is required.' }, status: 422 if params[:name].blank?
    return render json: { message: 'The email is required.' }, status: 422 if params[:email].blank?
    return render json: { message: 'The email is not in valid format.' }, status: 422 unless params[:email] =~ URI::MailTo::EMAIL_REGEXP
  end
end
