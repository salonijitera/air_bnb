class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :authorize_user!, only: [:create]
  def create
    user = User.find_by_id(params[:user_id]) || current_user
    if user
      if params[:name].blank?
        render json: { message: 'The name is required.' }, status: :unprocessable_entity
      elsif params[:name].length > 100
        render json: { message: 'You cannot input more 100 characters.' }, status: :unprocessable_entity
      elsif WishList.where(name: params[:name], user_id: user.id).exists?
        render json: { message: 'Wish list with this name already exists.' }, status: :unprocessable_entity
      else
        wish_list = WishList.create(name: params[:name], user_id: user.id)
        if wish_list.persisted?
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
