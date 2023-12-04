class Api::BookingsController < ApplicationController
  def index
    @bookings = Booking.includes(:listing)
                  .where(user_id: current_user.id)
                  .order(start_date: :asc)
    render :index
  end
  def show
    @booking = Booking.includes(:user).includes(:listing).find_by(id: params[:id])
    render :show
  end
  def create
    return render json: { error: 'Unauthorized' }, status: 401 unless user_signed_in?
    return render json: { error: 'Wrong format' }, status: 422 unless params[:property_id].is_a?(Integer) && params[:user_id].is_a?(Integer)
    property = Property.find_by(id: params[:property_id])
    user = User.find_by(id: params[:user_id])
    if property.nil? || user.nil?
      render json: { error: 'Invalid property or user id' }, status: 404
    elsif property.availability == false
      render json: { error: 'Property is not available' }, status: 400
    else
      property.update(availability: false)
      @booking = Booking.new(user_id: user.id, listing_id: property.id)
      if @booking.save
        render json: { status: 200, message: 'Property successfully booked', booking: @booking }
      else
        render json: { error: 'Failed to create booking' }, status: 500
      end
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
  def destroy
    @booking = Booking.find_by(id: params[:id])
    @booking.destroy!
    render json: ["Booking successfully removed."]
  end
  def update
    @booking = Booking.find_by(id: params[:id])
    if @booking.update(booking_params)
      render :show
    else
      render json: ['Unable to update booking'], status: 401
    end
  end
  private
  def booking_params
    params.require(:booking).permit(:id, :start_date, :end_date, :num_guests, :listing_id, :user_id)
  end
end
