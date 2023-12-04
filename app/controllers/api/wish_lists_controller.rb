class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list, :update_wish_list]
  before_action :authorize_user!, only: [:create, :update_wish_list]
  def create
    validator = WishListValidator.new(wish_list_params)
    unless validator.valid?
      render json: { errors: validator.errors.full_messages }, status: :bad_request
      return
    end
    begin
      wish_list = WishListService.create_wish_list(wish_list_params)
      render json: { status: 200, wish_list: wish_list }, status: :ok
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  def share_wish_list
    wish_list_id = params[:wish_list_id]
    user_id = params[:user_id]
    wish_list = WishList.find_by(id: wish_list_id)
    user = User.find_by(id: user_id)
    unless wish_list && user
      render json: { message: 'Invalid wish list or user id' }, status: :bad_request
      return
    end
    begin
      WishListService.share(wish_list, user)
      render json: { message: 'Wish list was successfully shared.' }, status: :ok
    rescue => e
      render json: { message: 'Failed to share wish list', error: e.message }, status: :internal_server_error
    end
  end
  def update_wish_list
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    unless WishList.exists?(wish_list_id) && Property.exists?(property_id)
      render json: { message: 'Invalid wish list or property id' }, status: :bad_request
      return
    end
    begin
      if WishListService.property_in_wish_list?(wish_list_id, property_id)
        WishListService.remove_property(wish_list_id, property_id)
      else
        WishListService.add_property(wish_list_id, property_id)
      end
      updated_wish_list = WishListService.get_wish_list(wish_list_id)
      render json: { message: 'Wish list updated successfully', wish_list: updated_wish_list }, status: :ok
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  private
  def wish_list_params
    params.require(:wish_list).permit(:name, :user_id)
  end
end
