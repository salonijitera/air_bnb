class Api::WishListItemsController < ApplicationController
  def create
    begin
      property_id = params[:property_id]
      wish_list_id = params[:wish_list_id]
      if Property.exists?(property_id) && WishList.exists?(wish_list_id)
        wish_list_item = WishListItem.new(property_id: property_id, wish_list_id: wish_list_id)
        if wish_list_item.save
          render json: { message: 'Wish list item added successfully', wish_list_item: wish_list_item }, status: :ok
        else
          render json: { error: 'Failed to add item to wish list' }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid property or wish list' }, status: :bad_request
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
