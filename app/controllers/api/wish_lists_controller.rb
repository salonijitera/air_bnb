class Api::WishListsController < ApplicationController
  def create
    user = User.find_by_id(params[:user_id])
    if user
      wish_list = user.wish_lists.new(name: params[:name])
      if wish_list.save
        render json: { message: 'Wish list created successfully', wish_list: wish_list }, status: :created
      else
        render json: { message: 'Failed to create wish list', errors: wish_list.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  end
end
