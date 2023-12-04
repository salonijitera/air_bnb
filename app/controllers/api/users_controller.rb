class Api::UsersController < ApplicationController
  before_action :authorize, only: [:update_profile]
  before_action :set_user, only: [:update_profile]
  before_action :validate_profile_params, only: [:update_profile]
  def update_profile
    if @user.user_profile.update(profile_params)
      render json: { message: 'Profile updated successfully', user: @user }, status: 200
    else
      render json: { message: 'Failed to update profile', errors: @user.user_profile.errors.full_messages }, status: 422
    end
  end
  private
  def set_user
    @user = User.find_by_id(params[:user_id])
    if @user.nil?
      render json: { error: 'User not found' }, status: 404
    elsif current_user != @user
      render json: { error: 'You are not authorized to perform this action' }, status: 403
    end
  end
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :date_of_birth, :profile_picture)
  end
  def validate_profile_params
    return render json: { message: 'The first name is required.' }, status: 422 if params[:first_name].blank?
    return render json: { message: 'The last name is required.' }, status: 422 if params[:last_name].blank?
    return render json: { message: 'The date of birth is required.' }, status: 422 if params[:date_of_birth].blank?
    return render json: { message: 'The date of birth is not in valid format.' }, status: 422 unless params[:date_of_birth] =~ /\d{4}-\d{2}-\d{2}/
  end
end
