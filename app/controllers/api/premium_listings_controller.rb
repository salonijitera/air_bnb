class Api::PremiumListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:destroy, :update]
  before_action :validate_params, only: [:destroy, :update]
  def create
    title = params[:title]
    description = params[:description]
    price = params[:price]
    user_id = params[:user_id]
    status = params[:status]
    posted_date = params[:posted_date]
    if title.blank?
      render json: { error: 'The title is required.' }, status: :bad_request
    elsif description.blank?
      render json: { error: 'The description is required.' }, status: :bad_request
    elsif !price.is_a?(Numeric)
      render json: { error: 'The price must be a number.' }, status: :bad_request
    elsif !User.exists?(user_id)
      render json: { error: 'The user_id is not valid.' }, status: :bad_request
    elsif !PremiumListing.statuses.include?(status)
      render json: { error: 'The status is not valid.' }, status: :bad_request
    elsif !posted_date.is_a?(Date)
      render json: { error: 'The posted_date is not a valid date.' }, status: :bad_request
    else
      listing = PremiumListing.create(title: title, description: description, price: price, user_id: user_id, status: status, posted_date: posted_date, created_at: Time.now, updated_at: Time.now)
      if listing.persisted?
        render json: { status: 200, premium_listing: listing }, status: :ok
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
  def update
    id = params[:id]
    title = params[:title]
    description = params[:description]
    price = params[:price]
    status = params[:status]
    posted_date = params[:posted_date]
    listing = PremiumListing.find_by(id: id)
    if listing.nil?
      render json: { error: 'Listing not found' }, status: :not_found
    else
      listing.update(title: title, description: description, price: price, status: status, posted_date: posted_date)
      if listing.save
        render json: { status: 200, premium_listing: {id: listing.id, title: listing.title, description: listing.description, price: listing.price, status: listing.status, posted_date: listing.posted_date, user_id: listing.user_id} }, status: :ok
      else
        render json: { error: listing.errors.full_messages }, status: :unprocessable_entity
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
    # ... existing code ...
  end
  private
  def authorize_user
    unless current_user.admin? || current_user.id == @listing.user_id
      render json: { status: ApiResponseCode::FORBIDDEN, message: ErrorMessage::FORBIDDEN }, status: :forbidden
    end
  end
  def validate_params
    validator = PremiumListingValidator.new(params)
    unless validator.valid?
      render json: { status: ApiResponseCode::BAD_REQUEST, message: validator.errors.full_messages }, status: :bad_request
    end
  end
end
