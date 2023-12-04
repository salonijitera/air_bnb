class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list]
  before_action :authorize_user!, only: [:create]
  def create
    validator = WishListValidator.new(wish_list_params)
    unless validator.valid?
      render json: { errors: validator.errors.full_messages }, status: :bad_request
      return
    end
    begin
      wish_list = WishListService.create_wish_list(wish_list_params)
      render json: { status: 200, wish_list: wish_list }, status: :ok
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  def share_wish_list
    wish_list_id = params[:wish_list_id]
    user_id = params[:user_id]
    unless WishList.exists?(wish_list_id) && User.exists?(user_id)
      render json: { message: 'Invalid wish list or user id' }, status: :bad_request
      return
    end
    if SharedWishList.exists?(wish_list_id: wish_list_id, user_id: user_id)
      render json: { message: 'Wish list already shared with this user' }, status: :bad_request
      return
    end
    shared_wish_list = SharedWishList.create(wish_list_id: wish_list_id, user_id: user_id)
    if shared_wish_list.persisted?
      render json: { message: 'Wish list shared successfully', shared_wish_list: shared_wish_list }, status: :ok
    else
      render json: { message: 'Failed to share wish list', errors: shared_wish_list.errors.full_messages }, status: :internal_server_error
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  def share
    # ... existing code ...
  end
  private
  def wish_list_params
    params.require(:wish_list).permit(:name, :user_id)
  end
  # ... rest of the code ...
end
