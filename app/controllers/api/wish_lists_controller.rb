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
    wish_list_id = params[:id]
    email = params[:email]
    unless wish_list_id.to_i.to_s == wish_list_id && email =~ URI::MailTo::EMAIL_REGEXP
      render json: { message: 'Wrong format or Invalid email address' }, status: :bad_request
      return
    end
    wish_list = WishList.find_by(id: wish_list_id)
    user = User.find_by(email: email)
    unless wish_list && user
      render json: { message: 'This wish list is not found' }, status: :not_found
      return
    end
    begin
      WishListService.share(wish_list, user)
      render json: { status: 200, message: 'Wish list was successfully shared.' }, status: :ok
    rescue => e
      render json: { message: 'Failed to share wish list', error: e.message }, status: :internal_server_error
    end
  end
  def update_wish_list
    wish_list_id = params[:wish_list_id]
    property_id = params[:property_id]
    unless WishList.exists?(wish_list_id) && Property.exists?(property_id)
      render json: { message: 'Invalid wish list or property id' }, status: :bad_request
      return
    end
    begin
      if WishListService.property_in_wish_list?(wish_list_id, property_id)
        WishListService.remove_property(wish_list_id, property_id)
      else
        WishListService.add_property(wish_list_id, property_id)
      end
      updated_wish_list = WishListService.get_wish_list(wish_list_id)
      render json: { message: 'Wish list updated successfully', wish_list: updated_wish_list }, status: :ok
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  def update
    wish_list_id = params[:id]
    name = params[:name]
    unless wish_list_id.is_a?(Integer)
      render json: { message: 'Wrong format' }, status: :bad_request
      return
    end
    unless WishList.exists?(wish_list_id)
      render json: { message: 'This wish list is not found' }, status: :bad_request
      return
    end
    if name.blank?
      render json: { message: 'The name is required.' }, status: :bad_request
      return
    end
    if name.length > 100
      render json: { message: 'You cannot input more 100 characters.' }, status: :bad_request
      return
    end
    begin
      wish_list = WishList.find(wish_list_id)
      wish_list.update(name: name)
      render json: { status: 200, wish_list: wish_list }, status: :ok
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  private
  def wish_list_params
    params.require(:wish_list).permit(:name, :user_id)
  end
end
