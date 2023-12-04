class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def add_property
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    # Validate parameters
    unless wish_list_id && property_id && wish_list_id.is_a?(Integer) && property_id.is_a?(Integer)
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    wish_list = WishList.find_by(id: wish_list_id)
    property = Property.find_by(id: property_id)
    # Check if wish list and property exist
    if wish_list.nil?
      render json: { error: 'This wish_list is not found' }, status: :not_found
      return
    elsif property.nil?
      render json: { error: 'This property is not found' }, status: :not_found
      return
    end
    # Check if property is already in wish list
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      render json: { error: 'Property already in wish list' }, status: :unprocessable_entity
      return
    end
    # Add property to wish list
    wish_list_item = WishListItem.create(wish_list_id: wish_list_id, property_id: property_id)
    if wish_list_item.persisted?
      render json: { status: 200, wish_list_item: wish_list_item }, status: :ok
    else
      render json: { error: 'Failed to add property to wish_list' }, status: :internal_server_error
    end
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
