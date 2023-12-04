class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list, :update_wish_list, :update]
  before_action :authorize_user!, only: [:create, :update_wish_list, :update]
  def create
    # ... existing code ...
  end
  def share_wish_list
    # ... existing code ...
  end
  def update_wish_list
    # ... existing code ...
  end
  def update
    wish_list_id = params[:id]
    name = params[:name]
    unless wish_list_id.is_a?(Integer)
      render json: { message: 'Wrong format' }, status: :bad_request
      return
    end
    unless WishList.exists?(wish_list_id)
      render json: { message: 'This wish list is not found' }, status: :bad_request
      return
    end
    if name.blank?
      render json: { message: 'The name is required.' }, status: :bad_request
      return
    end
    if name.length > 100
      render json: { message: 'You cannot input more 100 characters.' }, status: :bad_request
      return
    end
    begin
      wish_list = WishList.find(wish_list_id)
      wish_list.update(name: name)
      render json: { status: 200, wish_list: wish_list }, status: :ok
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  private
  def wish_list_params
    params.require(:wish_list).permit(:name, :user_id)
  end
end
