class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list]
  before_action :authorize_user!, only: [:create]
  def create
    user_id = params[:user_id]
    name = params[:name]
    # Validate user_id
    if user_id.blank? || !(user_id.is_a? Integer)
      render json: { message: 'Wrong format.' }, status: :bad_request
      return
    end
    # Find user
    user = User.find_by_id(user_id) || current_user
    if user.nil?
      render json: { message: 'This user is not found.' }, status: :not_found
      return
    end
    # Validate name
    if name.blank?
      render json: { message: 'The name is required.' }, status: :bad_request
      return
    elsif name.length > 100
      render json: { message: 'You cannot input more than 100 characters.' }, status: :bad_request
      return
    end
    # Create wish list
    begin
      wish_list = WishListService.createWishList(user.id, name)
      if wish_list
        render json: { status: 200, message: 'Wish list created successfully', wish_list: wish_list }, status: :created
      else
        render json: { message: 'Failed to create wish list', errors: wish_list.errors.full_messages }, status: :internal_server_error
      end
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  def share_wish_list
    # ... existing code ...
  end
  def share
    if params[:id].to_i.to_s != params[:id]
      render json: { message: 'Wrong format' }, status: :bad_request
      return
    end
    if params[:email] !~ URI::MailTo::EMAIL_REGEXP
      render json: { message: 'Invalid email format.' }, status: :bad_request
      return
    end
    wish_list = WishList.find_by_id(params[:id])
    if wish_list.nil?
      render json: { message: 'This wish list is not found' }, status: :not_found
      return
    end
    user = User.find_by_email(params[:email])
    if user.nil?
      render json: { message: 'User not found' }, status: :not_found
      return
    end
    if wish_list.user_id != current_user.id
      render json: { message: 'You do not have permission to share this wish_list' }, status: :forbidden
      return
    end
    shared_wish_list = SharedWishList.create(wish_list_id: wish_list.id, user_id: user.id)
    if shared_wish_list.persisted?
      ApplicationMailer.share_wish_list_email(user, wish_list).deliver_now
      render json: { status: 200, message: 'Wish list was successfully shared.' }, status: :ok
    else
      render json: { message: 'Failed to share wish list' }, status: :unprocessable_entity
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  # ... rest of the code ...
end
