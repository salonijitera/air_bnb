class Api::WishListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  def create
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    # Validate parameters
    unless wish_list_id && property_id && wish_list_id.is_a?(Integer) && property_id.is_a?(Integer)
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    begin
      # Use WishListService to validate and add property to wish list
      wish_list_item = WishListService.add_property_to_wish_list(wish_list_id, property_id)
      # Return success message and updated wish list
      render json: { status: 200, message: 'Property added to wish list successfully', wish_list_item: WishListItemSerializer.new(wish_list_item) }, status: :ok
    rescue ErrorMessage::InvalidParameters => e
      render json: { error: e.message }, status: :bad_request
    rescue ErrorMessage::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue ErrorMessage::RecordAlreadyExists => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: 'Internal Server Error', message: e.message }, status: :internal_server_error
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
