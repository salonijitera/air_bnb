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
  def share_wish_list
    wish_list_id = params[:wish_list_id]
    user_id = params[:user_id]
    wish_list = WishList.find_by(id: wish_list_id)
    user = User.find_by(id: user_id)
    if wish_list.nil? || user.nil?
      render json: { error: 'Wish list or user not found' }, status: :not_found
      return
    end
    shared_link = generate_shared_link(wish_list_id)
    send_shared_link_to_user(user, shared_link)
    render json: { message: 'Wish list shared successfully' }, status: :ok
  end
  private
  def generate_shared_link(wish_list_id)
    "https://yourwebsite.com/wish_lists/#{wish_list_id}"
  end
  def send_shared_link_to_user(user, shared_link)
    # This is a placeholder and should be replaced with your actual implementation.
    # For example, you could send an email or a notification within your application.
    # UserMailer.share_wish_list(user, shared_link).deliver_now
  end
end
