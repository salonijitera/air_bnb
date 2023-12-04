class Api::PremiumListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:destroy]
  before_action :validate_params, only: [:destroy]
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
  def destroy
    begin
      premium_listing = PremiumListing.find_by(id: params[:id])
      if premium_listing.nil?
        render json: { status: ApiResponseCode::NOT_FOUND, message: 'This premium listing is not found' }, status: :not_found
      else
        if premium_listing.destroy
          render json: { status: ApiResponseCode::OK, message: 'Premium listing was successfully deleted.' }, status: :ok
        else
          render json: { status: ApiResponseCode::INTERNAL_SERVER_ERROR, message: premium_listing.errors.full_messages }, status: :internal_server_error
        end
      end
    rescue => e
      render json: { status: ApiResponseCode::INTERNAL_SERVER_ERROR, message: ErrorMessage::UNEXPECTED_ERROR }, status: :internal_server_error
    end
  end
  private
  def authorize_user
    unless current_user.admin?
      render json: { status: ApiResponseCode::FORBIDDEN, message: ErrorMessage::FORBIDDEN }, status: :forbidden
    end
  end
  def validate_params
    unless params[:id].is_a?(Integer)
      render json: { status: ApiResponseCode::BAD_REQUEST, message: 'Wrong format' }, status: :bad_request
    end
  end
end
