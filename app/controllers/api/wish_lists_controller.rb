class Api::WishListsController < ApplicationController
  def create
    user = User.find_by_id(params[:user_id])
    if user
      wish_list = user.wish_lists.new(name: params[:name])
      if wish_list.save
        render json: { message: 'Wish list created successfully', wish_list: wish_list }, status: :created
      else
        render json: { message: 'Failed to create wish list', errors: wish_list.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  end
  def share
    id = params[:id]
    email = params[:email]
    # Validate parameters
    unless id.is_a?(Integer)
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    unless email =~ URI::MailTo::EMAIL_REGEXP
      render json: { error: 'Invalid email format' }, status: :bad_request
      return
    end
    # Check if user is authenticated
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end
    # Check if user has permission to access the wish list
    wish_list = WishList.find_by(id: id)
    unless wish_list && wish_list.user_id == current_user.id
      render json: { error: 'Forbidden' }, status: :forbidden
      return
    end
    # Attempt to share the wish list
    if share_wish_list(email)
      render json: { status: 200, message: 'Wish list was successfully shared.' }, status: :ok
    else
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
  private
  def share_wish_list(email)
    # This is a placeholder and should be replaced with your actual implementation.
    # For example, you could send an email or a notification within your application.
    # UserMailer.share_wish_list(email, shared_link).deliver_now
  end
end
