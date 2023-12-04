class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list]
  before_action :authorize_user!, only: [:create]
  def create
    user_id = params[:user_id]
    name = params[:name]
    # Validate input parameters
    validator = WishListValidator.new(user_id: user_id, name: name)
    unless validator.valid?
      render json: { message: validator.errors.full_messages }, status: :bad_request
      return
    end
    # Create wish list
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
    # ... existing code ...
  end
  def share
    # ... existing code ...
  end
  # ... rest of the code ...
end
