class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def add_property
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    unless WishList.exists?(wish_list_id) && Property.exists?(property_id)
      render json: { error: 'Invalid wish list or property' }, status: :bad_request
      return
    end
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      render json: { error: 'Property already added to the wish list' }, status: :unprocessable_entity
      return
    end
    wish_list_item = WishListItem.create(wish_list_id: wish_list_id, property_id: property_id)
    if wish_list_item.persisted?
      render json: { message: 'Property added to wish list successfully', wish_list: WishList.find(wish_list_id) }, status: :ok
    else
      render json: { error: 'Failed to add property to wish list' }, status: :unprocessable_entity
    end
  end
  private
  def authenticate_user!
    # Implement authentication logic here
  end
  def authorize_user!
    # Implement authorization logic here
  end
end
