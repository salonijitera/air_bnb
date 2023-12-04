class Api::PremiumListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:destroy]
  before_action :validate_params, only: [:destroy]
  def create
    listing_name = params[:listing_name]
    listing_status = params[:listing_status]
    if listing_name.is_a?(String) && listing_name.length <= 200 && PremiumListing.statuses.include?(listing_status)
      listing = PremiumListing.create(listing_name: listing_name, listing_status: listing_status, created_at: Time.now, updated_at: Time.now)
      if listing.persisted?
        render json: { status: 200, premium_listing: listing }, status: :ok
      else
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
  def update
    id = params[:id]
    title = params[:title]
    description = params[:description]
    price = params[:price]
    status = params[:status]
    listing = PremiumListing.find_by(id: id)
    if listing.nil?
      render json: { error: 'Listing not found' }, status: :not_found
    else
      listing.update(title: title, description: description, price: price, status: status)
      if listing.save
        render json: { status: 200, premium_listing: {id: listing.id, title: listing.title, description: listing.description, price: listing.price, status: listing.status} }, status: :ok
      else
        render json: { error: listing.errors.full_messages }, status: :internal_server_error
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
