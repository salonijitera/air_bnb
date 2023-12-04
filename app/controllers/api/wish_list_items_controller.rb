class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def create
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    # Validate parameters
    unless WishList.exists?(wish_list_id) && Property.exists?(property_id)
      render json: { error: 'Invalid wish list or property' }, status: :bad_request
      return
    end
    # Check if property is already added to the wish list
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      render json: { error: 'Property already added to the wish list' }, status: :unprocessable_entity
      return
    end
    # Add property to the wish list
    wish_list_item = WishListItem.create(wish_list_id: wish_list_id, property_id: property_id)
    # Return success message and updated wish list
    wish_list = WishList.find(wish_list_id)
    render json: { status: 200, message: 'Property added to wish list successfully', wish_list: wish_list }, status: :ok
  rescue => e
    render json: { error: 'Internal Server Error', message: e.message }, status: :internal_server_error
  end
  private
  def authenticate_user!
    # Implement authentication logic here
  end
  def authorize_user!
    # Implement authorization logic here
  end
end
