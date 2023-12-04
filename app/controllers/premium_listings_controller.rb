class PremiumListingsController < ApplicationController
  # Other methods...
  def retrieve_vip_listings
    begin
      user_id = params[:user_id].to_i
      if user_id <= 0
        render json: { error: 'Wrong format' }, status: :bad_request
      else
        @listings = PremiumListing.where(user_id: user_id)
        if @listings.empty?
          render json: { error: 'No listings found for this user' }, status: :not_found
        else
          render json: @listings, status: :ok
        end
      end
    rescue => e
      render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
    end
  end
end
