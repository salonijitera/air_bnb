class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def create
    begin
      property_id = params[:property_id]
      wish_list_id = params[:wish_list_id]
      # Validate the property_id and wish_list_id
      validator = WishListItemValidator.new(property_id: property_id, wish_list_id: wish_list_id)
      unless validator.valid?
        render json: { error: 'Wrong format' }, status: :unprocessable_entity
        return
      end
      if Property.exists?(property_id) && WishList.exists?(wish_list_id)
        wish_list_item = WishListItem.new(property_id: property_id, wish_list_id: wish_list_id)
        if wish_list_item.save
          render json: { status: 200, wish_list_item: wish_list_item }, status: :ok
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
  private
  def authenticate_user!
    # Implement authentication logic here
  end
  def authorize_user!
    # Implement authorization logic here
  end
end
