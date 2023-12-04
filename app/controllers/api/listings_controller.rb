class Api::ListingsController < ApplicationController
  # Other methods...
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
