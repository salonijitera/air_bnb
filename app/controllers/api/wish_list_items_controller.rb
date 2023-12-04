class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def add_property
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    wish_list = WishList.find_by(id: wish_list_id)
    property = Property.find_by(id: property_id)
    unless wish_list && property
      render json: { error: 'Wish list or property not found' }, status: :not_found
      return
    end
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      render json: { error: 'Property already in wish list' }, status: :unprocessable_entity
      return
    end
    wish_list_item = WishListItem.create(wish_list_id: wish_list_id, property_id: property_id)
    if wish_list_item.persisted?
      render json: { status: 200, message: 'Property successfully added to wish list', wish_list: wish_list }, status: :ok
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
