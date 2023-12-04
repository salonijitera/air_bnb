class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list]
  before_action :authorize_user!, only: [:create]
  def create
    user_id = params[:user_id]
    name = params[:name]
    validator = WishListValidator.new(user_id: user_id, name: name)
    unless validator.valid?
      render json: { message: validator.errors.full_messages }, status: :bad_request
      return
    end
    wish_list_service = WishListService.new(user_id: user_id, name: name)
    wish_list = wish_list_service.create_wish_list
    if wish_list.persisted?
      render json: { status: 200, wish_list: wish_list }, status: :ok
    else
      render json: { message: 'Failed to create wish list', errors: wish_list.errors.full_messages }, status: :internal_server_error
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  def share_wish_list
    wish_list_id = params[:wish_list_id]
    user_id = params[:user_id]
    wish_list = WishList.find_by(id: wish_list_id)
    user = User.find_by(id: user_id)
    unless wish_list && user
      render json: { message: 'Invalid wish list or user id' }, status: :bad_request
      return
    end
    unless wish_list.user_id == user.id || wish_list.public?
      render json: { message: 'You do not have permission to view this wish list' }, status: :forbidden
      return
    end
    WishListMailer.with(wish_list: wish_list, user: user).share_wish_list.deliver_now
    render json: { message: 'Wish list shared successfully' }, status: :ok
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  def share
    # ... existing code ...
  end
  # ... rest of the code ...
end
