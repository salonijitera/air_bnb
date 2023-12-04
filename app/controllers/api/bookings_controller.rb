class Api::BookingsController < ApplicationController
  before_action :authenticate_user!
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
    return render json: { error: 'Wrong format' }, status: 422 unless params[:booking][:property_id].is_a?(Integer) && params[:booking][:user_id].is_a?(Integer)
    unless User.exists?(params[:booking][:user_id]) && Property.exists?(params[:booking][:property_id])
      return render json: { error: 'Invalid user or property id' }, status: 404
    end
    property = Property.find_by(id: params[:booking][:property_id])
    user = User.find_by(id: params[:booking][:user_id])
    if property.availability == false
      render json: { error: 'Property is not available' }, status: 400
    else
      property.update(availability: false)
      @booking = Booking.new(user_id: user.id, listing_id: property.id, date_from: params[:booking][:date_from], date_to: params[:booking][:date_to])
      if @booking.save
        # Send confirmation to the user
        Notification.create(user_id: user.id, message: 'Booking confirmed', status: 'unread')
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
    params.require(:booking).permit(:property_id, :user_id, :date_from, :date_to)
  end
end
