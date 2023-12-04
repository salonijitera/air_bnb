class Api::PremiumListingsController < ApplicationController
  before_action :authenticate_user!
  def create
    listing_name = params[:listing_name]
    listing_status = params[:listing_status]
    # Validate the input parameters
    if listing_name.is_a?(String) && listing_name.length <= 200 && PremiumListing.statuses.include?(listing_status)
      # Create a new record in the premium_listing table
      listing = PremiumListing.create(listing_name: listing_name, listing_status: listing_status, created_at: Time.now, updated_at: Time.now)
      if listing.persisted?
        # Return the ID of the newly created premium listing
        render json: { status: 200, premium_listing: listing }, status: :ok
      else
        # Return an error message
        render json: { error: listing.errors.full_messages }, status: :internal_server_error
      end
    else
      if listing_name.length > 200
        render json: { error: 'You cannot input more 200 characters.' }, status: :bad_request
      else
        render json: { error: 'Invalid listing status.' }, status: :bad_request
      end
    end
  rescue => e
    if e.class == ActiveRecord::RecordNotFound
      render json: { error: 'Not Found' }, status: :not_found
    elsif e.class == ActionController::ParameterMissing
      render json: { error: 'Bad Request' }, status: :bad_request
    else
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
end
