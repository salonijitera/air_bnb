class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share, :create, :share_wish_list]
  before_action :authorize_user!, only: [:create]
  def create
    user = User.find_by_id(params[:user_id]) || current_user
    if user
      if params[:name].blank?
        render json: { message: 'The name is required.' }, status: :unprocessable_entity
      elsif params[:name].length > 100
        render json: { message: 'You cannot input more 100 characters.' }, status: :unprocessable_entity
      else
        wish_list = WishListService.createWishList(user.id, params[:name])
        if wish_list
          render json: { status: 200, message: 'Wish list created successfully', wish_list: wish_list }, status: :created
        else
          render json: { message: 'Failed to create wish list', errors: wish_list.errors.full_messages }, status: :unprocessable_entity
        end
      end
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  # ... rest of the code
end
