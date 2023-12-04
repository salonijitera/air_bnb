class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list, :update_wish_list, :update]
  before_action :authorize_user!, only: [:create, :update_wish_list, :update]
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
  # Other methods...
  private
  def wish_list_params
    params.require(:wish_list).permit(:name, :user_id)
  end
end
