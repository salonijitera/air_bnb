class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list]
  before_action :authorize_user!, only: [:create]
  def create
    # ... existing code ...
  end
  def share_wish_list
    wish_list_id = params[:wish_list_id]
    user_id = params[:user_id]
    # Validate wish_list_id and user_id
    if wish_list_id.blank? || user_id.blank?
      render json: { message: 'Wrong format.' }, status: :bad_request
      return
    end
    # Find wish list and user
    wish_list = WishList.find_by_id(wish_list_id)
    user = User.find_by_id(user_id)
    if wish_list.nil? || user.nil?
      render json: { message: 'Wish list or user not found.' }, status: :not_found
      return
    end
    # Check if the wish list is already shared with the user
    shared_wish_list = SharedWishList.find_by(wish_list_id: wish_list_id, user_id: user_id)
    if shared_wish_list
      render json: { message: 'This wish list is already shared with the user.' }, status: :bad_request
      return
    end
    # Create a new entry in the shared_wish_lists table
    shared_wish_list = SharedWishList.create(wish_list_id: wish_list_id, user_id: user_id)
    if shared_wish_list.persisted?
      render json: { status: 200, message: 'Wish list was successfully shared.', shared_wish_list: shared_wish_list }, status: :ok
    else
      render json: { message: 'Failed to share wish list', errors: shared_wish_list.errors.full_messages }, status: :internal_server_error
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  def share
    # ... existing code ...
  end
  # ... rest of the code ...
end
