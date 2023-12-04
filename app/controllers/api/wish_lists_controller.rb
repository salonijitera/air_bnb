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
      elsif WishList.where(name: params[:name], user_id: user.id).exists?
        render json: { message: 'Wish list with this name already exists.' }, status: :unprocessable_entity
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
  def share_wish_list
    wish_list = WishList.find_by_id(params[:wish_list_id])
    user = User.find_by_id(params[:user_id])
    if wish_list.nil? || user.nil?
      render json: { message: 'Wish list or User not found' }, status: :not_found
      return
    end
    if wish_list.user_id != current_user.id
      render json: { message: 'You do not have permission to share this wish list' }, status: :forbidden
      return
    end
    shared_wish_list = SharedWishList.create(wish_list_id: wish_list.id, user_id: user.id)
    if shared_wish_list.persisted?
      ApplicationMailer.share_wish_list_email(user, wish_list).deliver_now
      render json: { message: 'Wish list shared successfully' }, status: :ok
    else
      render json: { message: 'Failed to share wish list', errors: shared_wish_list.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
  end
  # ... rest of the code
end
