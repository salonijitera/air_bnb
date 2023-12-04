class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def create
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    # Validate parameters
    unless wish_list_id.is_a?(Integer) && property_id.is_a?(Integer)
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    unless WishList.exists?(wish_list_id) && Property.exists?(property_id)
      render json: { error: 'This wish list or property is not found' }, status: :bad_request
      return
    end
    # Check if property is already added to the wish list
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      render json: { error: 'Property already added to the wish list' }, status: :unprocessable_entity
      return
    end
    # Add property to the wish list
    wish_list_item = WishListItem.create(wish_list_id: wish_list_id, property_id: property_id)
    render json: { status: 200, wish_list_item: wish_list_item }, status: :ok
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
