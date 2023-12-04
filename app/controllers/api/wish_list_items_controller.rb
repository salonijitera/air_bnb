class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  def create
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    unless wish_list_id.is_a?(Integer) && property_id.is_a?(Integer)
      return render json: { error: 'Wrong format' }, status: 422
    end
    unless WishList.exists?(wish_list_id)
      return render json: { error: 'This wish list is not found' }, status: 400
    end
    unless Property.exists?(property_id)
      return render json: { error: 'This property is not found' }, status: 400
    end
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      return render json: { error: 'Property is already in the wish list' }, status: 400
    end
    wish_list_item = WishListItem.new(wish_list_id: wish_list_id, property_id: property_id)
    if wish_list_item.save
      render json: { status: 200, wish_list_item: wish_list_item }, status: 200
    else
      render json: { error: 'Failed to add property to the wish list' }, status: 500
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
end
