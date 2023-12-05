class Api::ListingsController < ApplicationController
  # Other methods...
  def create
    # Check if the user is authenticated and is a premium user
    if current_user && current_user.is_premium
      # Use strong parameters to permit the required parameters
      listing_params = params.require(:listing).permit(:title, :description, :is_premium, :user_id)
      # Implement validation checks for the parameters
      if listing_params[:title].is_a?(String) && listing_params[:title].length <= 200 && listing_params[:description].is_a?(String) && listing_params[:description].length <= 10000 && [true, false].include?(listing_params[:is_premium]) && User.exists?(listing_params[:user_id])
        # If all checks pass, create a new premium listing with the provided parameters and save it to the database
        listing = Listing.new(listing_params)
        if listing.save
          # If the listing is successfully created, return a 200 Success status with the listing data in the response body
          render json: { status: 200, listing: listing }, status: :ok
        else
          # If there is an error while saving the listing, return a 500 Internal Server Error status
          render json: { error: listing.errors.full_messages }, status: :internal_server_error
        end
      else
        # If any of the parameters are invalid, return a 400 Bad Request status with the appropriate error message
        error_message = ''
        error_message += 'You cannot input more 200 characters.' if listing_params[:title].length > 200
        error_message += 'You cannot input more 10000 characters.' if listing_params[:description].length > 10000
        error_message += 'Wrong format.' unless [true, false].include?(listing_params[:is_premium])
        error_message += 'User not found.' unless User.exists?(listing_params[:user_id])
        render json: { error: error_message }, status: :bad_request
      end
    else
      # If the user is not authenticated or is not a premium user, return a 401 Unauthorized or 403 Forbidden status
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue => e
    # Handle any unexpected errors by rescuing them and returning a 500 Internal Server Error status with an appropriate error message
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end
  # Other methods...
end
