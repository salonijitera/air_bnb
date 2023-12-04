class Api::PremiumListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:destroy, :update, :update_premium_status]
  before_action :validate_params, only: [:destroy, :update, :update_premium_status]
  def retrieve_vip_listings
    user_id = params[:user_id]
    @premium_listings = PremiumListing.where(user_id: user_id)
    if @premium_listings.empty?
      render json: { message: 'No premium listings found for this user.' }, status: :not_found
    else
      render json: @premium_listings, each_serializer: PremiumListingSerializer
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  def update_premium_status
    user_id = params[:user_id]
    is_premium = params[:is_premium]
    if user_id.blank? || is_premium.blank?
      render json: { error: 'Both user_id and is_premium are required.' }, status: :bad_request
    elsif !User.exists?(user_id)
      render json: { error: 'The user_id is not valid.' }, status: :bad_request
    else
      bookings = Booking.where(user_id: user_id)
      bookings.update_all(is_premium: is_premium)
      render json: { status: 200, message: 'Premium status updated successfully.' }, status: :ok
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
