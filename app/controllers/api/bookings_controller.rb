class Api::BookingsController < ApplicationController
  before_action :authenticate_user!
  def index
    begin
      @bookings = Booking.all
      @total_bookings = @bookings.count
      @total_pages = (@total_bookings / 10.0).ceil
      render json: { bookings: @bookings, total_bookings: @total_bookings, total_pages: @total_pages }
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  # ... rest of the code ...
end
