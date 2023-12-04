class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list, :update_wish_list]
  before_action :authorize_user!, only: [:create, :update_wish_list]
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
