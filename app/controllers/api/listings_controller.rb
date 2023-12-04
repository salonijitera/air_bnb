class Api::ListingsController < ApplicationController
  # Other methods...
  def create_premium_listing
    listing_name = params[:listing_name]
    listing_status = params[:listing_status]
    # Validate the input parameters
    if listing_name.is_a?(String) && PremiumListing.statuses.include?(listing_status)
      # Create a new record in the premium_listing table
      listing = PremiumListing.create(listing_name: listing_name, listing_status: listing_status, created_at: Time.now, updated_at: Time.now)
      if listing.persisted?
        # Return the ID of the newly created premium listing
        render json: { status: 200, message: 'Premium listing created successfully', id: listing.id }, status: :ok
      else
        # Return an error message
        render json: { error: listing.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid input parameters' }, status: :bad_request
    end
  end
  def delete_premium_listing
    begin
      listing_id = params[:id].to_i
      if listing_id <= 0
        render json: { error: 'Wrong format' }, status: :bad_request
      else
        listing = PremiumListing.find_by(id: listing_id)
        if listing.nil?
          render json: { error: 'This listing is not found' }, status: :not_found
        else
          if listing.destroy
            render json: { status: 200, message: 'Listing deleted successfully' }, status: :ok
          else
            render json: { error: listing.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    rescue => e
      render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
    end
  end
end
