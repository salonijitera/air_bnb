class Api::SessionsController < ApplicationController
  def create
    @user = User.find_by_credentials(
      params[:user][:username], 
      params[:user][:password]
    )
    if @user
      login!(@user)
      render :show
    else
      render json: ['Incorrect username/password combo. Please try again.'], status: 401
    end
  end
  def destroy
    if current_user
      logout!
      render json: {}
    else
      render json: ["No currently logged in user"], status: 401
    end
  end
  def update
    @user = User.find(params[:id])
    if @user
      @user.email = params[:email]
      @user.password = params[:password]
      if @user.save
        render json: { message: 'Profile updated successfully', user: @user }, status: 200
      else
        render json: { message: 'Failed to update profile', errors: @user.errors.full_messages }, status: 422
      end
    else
      render json: { message: 'User not found' }, status: 404
    end
  end
end
