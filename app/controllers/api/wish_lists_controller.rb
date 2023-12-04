class Api::WishListsController < ApplicationController
  def create
    user = User.find_by_id(params[:user_id])
    if user
      wish_list = user.wish_lists.new(name: params[:name])
      if wish_list.save
        render json: { status: 200, message: 'Wish list created successfully', wish_list: wish_list }, status: :created
      else
        render json: { message: 'Failed to create wish list', errors: wish_list.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  def share_wish_list
    wish_list = WishList.find_by_id(params[:wish_list_id])
    user = User.find_by_id(params[:user_id])
    if wish_list && user
      shared_wish_list = SharedWishList.create(wish_list_id: wish_list.id, user_id: user.id)
      if shared_wish_list.persisted?
        render json: { status: 200, message: 'Wish list has been successfully shared.' }, status: :ok
      else
        render json: { message: 'Failed to share wish list', errors: shared_wish_list.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Wish list or User not found' }, status: :not_found
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
end
