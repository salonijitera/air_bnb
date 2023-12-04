class Api::WishListsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :authorize_user!, only: [:create]
  def create
    user_id = params[:user_id]
    name = params[:name]
    # Validate user_id
    if user_id.blank? || !(user_id.is_a? Integer)
      render json: { message: 'Wrong format.' }, status: :bad_request
      return
    end
    # Find user
    user = User.find_by_id(user_id) || current_user
    if user.nil?
      render json: { message: 'This user is not found.' }, status: :not_found
      return
    end
    # Validate name
    if name.blank?
      render json: { message: 'The name is required.' }, status: :bad_request
      return
    elsif name.length > 100
      render json: { message: 'You cannot input more than 100 characters.' }, status: :bad_request
      return
    end
    # Create wish list
    begin
      wish_list = WishListService.createWishList(user.id, name)
      if wish_list
        render json: { status: 200, message: 'Wish list created successfully', wish_list: wish_list }, status: :created
      else
        render json: { message: 'Failed to create wish list', errors: wish_list.errors.full_messages }, status: :internal_server_error
      end
    rescue => e
      render json: { message: 'Internal Server Error', error: e.message }, status: :internal_server_error
    end
  end
  # ... rest of the code
end
