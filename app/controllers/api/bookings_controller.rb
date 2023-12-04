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
        render json: @booking, status: 201
      else
        render json: { error: 'Failed to create booking' }, status: 500
      end
    end
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
