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
  def share
    wish_list_id = params[:wish_list_id]
    user_id = params[:user_id]
    wish_list = WishList.find_by(id: wish_list_id)
    user = User.find_by(id: user_id)
    unless wish_list && user
      render json: { message: 'Wish list or user not found' }, status: :not_found
      return
    end
    if wish_list.collaborators.include?(user)
      render json: { message: 'User is already a collaborator' }, status: :bad_request
      return
    end
    begin
      wish_list.add_collaborator(user)
      NotificationsController.new.send_notification(user, "You have been added as a collaborator to the wish list #{wish_list.name}")
      render json: { status: 200, wish_list: { id: wish_list.id, name: wish_list.name, collaborators: wish_list.collaborators } }, status: :ok
    rescue => e
      render json: { message: 'Failed to share wish list', error: e.message }, status: :internal_server_error
    end
  end
  private
  def wish_list_params
    params.require(:wish_list).permit(:name, :user_id)
  end
end
