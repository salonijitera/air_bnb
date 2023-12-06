class Api::UsersController < ApplicationController
  before_action :authorize, only: [:check_vip_status, :vip_status, :update]
  # Other methods...
  def update
    if params[:id].to_i.to_s != params[:id]
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    @user = User.find_by(id: params[:id])
    if @user.nil?
      render json: { error: 'This user is not found' }, status: :not_found
      return
    end
    if params[:user][:name].blank?
      render json: { error: 'The name is required.' }, status: :unprocessable_entity
      return
    end
    if params[:user][:email].blank?
      render json: { error: 'The email is required.' }, status: :unprocessable_entity
      return
    end
    if params[:user][:email] !~ URI::MailTo::EMAIL_REGEXP
      render json: { error: 'Invalid email format.' }, status: :unprocessable_entity
      return
    end
    if @user.update(user_params)
      render json: { status: 200, user: { id: @user.id, name: @user.name, email: @user.email } }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # Other methods...
  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
