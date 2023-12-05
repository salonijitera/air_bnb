class Api::UsersController < ApplicationController
  before_action :authorize, only: [:check_vip_status, :vip_status, :mark_as_vip, :update]
  def create
    @user = User.new(user_params)
    if @user.valid?
      existing_user = User.find_by(email: @user.email)
      if existing_user.nil?
        @user.save
        UserMailer.confirmation_email(@user).deliver_now
        render json: { id: @user.id, name: @user.name, email: @user.email, location: @user.location }, status: :created
      else
        render json: { error: 'Email already registered' }, status: :unprocessable_entity
      end
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    user = User.find_by(id: params[:id])
    if user.nil?
      render json: { error: 'This user is not found' }, status: :not_found
    elsif user.id != current_user.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    else
      validator = UserValidator.new(user_params)
      if validator.valid?
        user.update_attributes(user_params)
        render json: { status: 200, user: { id: user.id, name: user.name, email: user.email } }, status: :ok
      else
        render json: { errors: validator.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  # ... rest of the code
end
