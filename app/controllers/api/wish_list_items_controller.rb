class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def create
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    unless wish_list_id.is_a?(Integer) && property_id.is_a?(Integer)
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    unless WishList.exists?(wish_list_id) && Property.exists?(property_id)
      render json: { error: 'This wish list or property is not found' }, status: :not_found
      return
    end
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      render json: { error: 'The property is already in the wish list' }, status: :unprocessable_entity
      return
    end
    wish_list_item = WishListItem.create(wish_list_id: wish_list_id, property_id: property_id)
    if wish_list_item.persisted?
      render json: { status: 200, wish_list_item: wish_list_item }, status: :ok
    else
      render json: { error: 'Failed to add property to wish list' }, status: :internal_server_error
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
