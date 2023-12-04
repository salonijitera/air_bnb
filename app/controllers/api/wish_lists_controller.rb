class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:share]
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
  def share
    wish_list = WishList.find_by_id(params[:id])
    email = params[:email]
    if wish_list.nil?
      render json: { message: 'This wish list is not found' }, status: :unprocessable_entity
    elsif !params[:id].to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/)
      render json: { message: 'Wrong format' }, status: :unprocessable_entity
    elsif email.blank? || !email.match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
      render json: { message: 'Invalid email format.' }, status: :unprocessable_entity
    else
      begin
        WishListSharingService.shareWishList(wish_list.id, email)
        render json: { status: 200, message: 'Wish list was successfully shared.' }, status: :ok
      rescue => e
        render json: { message: 'Failed to share wish list', error: e.message }, status: :internal_server_error
      end
    end
  end
end
