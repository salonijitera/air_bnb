class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def create
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    # Validate parameters
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
    WishListItem.create(wish_list_id: wish_list_id, property_id: property_id)
    flash[:notice] = 'Property has been successfully added to the wish list'
    wish_list = WishList.find(wish_list_id)
    render json: { wish_list: wish_list, properties: wish_list.properties }, status: :ok
  end
  private
  def authenticate_user!
    # Implement authentication logic here
  end
  def authorize_user!
    # Implement authorization logic here
  end
end
