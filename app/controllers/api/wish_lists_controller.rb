class Api::WishListsController < ApplicationController
  before_action :authenticate_user!
  def create
    return render json: { error: 'Unauthorized' }, status: 401 unless user_signed_in?
    return render json: { error: 'Name cannot be empty' }, status: 422 if params[:name].blank?
    return render json: { error: 'Wish list with this name already exists' }, status: 422 if WishList.exists?(name: params[:name], user_id: current_user.id)
    @wish_list = WishList.new(name: params[:name], user_id: current_user.id)
    if @wish_list.save
      # Send confirmation to the user
      Notification.create(user_id: current_user.id, message: 'Wish list created', status: 'unread')
      render json: @wish_list, status: 200
    else
      render json: { error: 'Failed to create wish list' }, status: 500
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
end
