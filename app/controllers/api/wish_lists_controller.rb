class Api::WishListsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_wish_list, only: [:share_wish_list]
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
  def add_property
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    # Validate wish_list_id and property_id
    unless WishList.exists?(wish_list_id) && Property.exists?(property_id)
      return render json: { error: 'Invalid wish list or property id' }, status: 404
    end
    # Check if the property is already in the wish list
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      return render json: { error: 'Property is already in the wish list' }, status: 400
    end
    # Add the property to the wish list
    wish_list_item = WishListItem.new(wish_list_id: wish_list_id, property_id: property_id)
    if wish_list_item.save
      # Send confirmation to the user
      render json: { status: 200, message: 'Property successfully added to the wish list', wish_list: WishList.find(wish_list_id).as_json(include: :properties) }
    else
      render json: { error: 'Failed to add property to the wish list' }, status: 500
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
  def share_wish_list
    begin
      user = User.find(params[:user_id])
      if @wish_list.users.include?(user)
        render json: { error: "User is already a collaborator" }, status: 422
      else
        @wish_list.users << user
        @wish_list.save
        NotificationService.new(user, "You have been added as a collaborator to the wish list: #{@wish_list.name}").send
        render 'show.json.jbuilder', status: 200
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User or WishList not found" }, status: 404
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  private
  def find_wish_list
    @wish_list = WishList.find(params[:wish_list_id])
  end
end
