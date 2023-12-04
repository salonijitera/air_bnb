class Api::WishListsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_wish_list, only: [:share_wish_list]
  def create
    return render json: { error: 'Unauthorized' }, status: 401 unless user_signed_in?
    return render json: { error: 'Wrong format' }, status: 400 unless params[:user_id].is_a?(Integer)
    return render json: { error: 'The name is required.' }, status: 422 if params[:name].blank?
    return render json: { error: 'You cannot input more 100 characters.' }, status: 422 if params[:name].length > 100
    return render json: { error: 'This user is not found' }, status: 400 unless User.exists?(params[:user_id])
    return render json: { error: 'Wish list with this name already exists' }, status: 422 if WishList.exists?(name: params[:name], user_id: params[:user_id])
    @wish_list = WishList.new(name: params[:name], user_id: params[:user_id])
    if @wish_list.save
      # Send confirmation to the user
      Notification.create(user_id: params[:user_id], message: 'Wish list created', status: 'unread')
      render json: { status: 200, wish_list: @wish_list }, status: 200
    else
      render json: { error: 'Failed to create wish_list' }, status: 500
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
  # ... rest of the code
end
