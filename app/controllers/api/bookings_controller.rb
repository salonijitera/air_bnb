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
    return render json: { error: 'Wrong format' }, status: 422 unless params[:id].is_a?(Integer) && params[:user_id].is_a?(Integer)
    unless User.exists?(params[:user_id]) && Property.exists?(params[:id])
      return render json: { error: 'Invalid user or property id' }, status: 404
    end
    property = Property.find_by(id: params[:id])
    user = User.find_by(id: params[:user_id])
    if property.availability == false
      render json: { error: 'Property is not available' }, status: 400
    else
      property.update(availability: false)
      @booking = Booking.new(user_id: user.id, listing_id: property.id, date_from: params[:date_from], date_to: params[:date_to])
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
  def book
    return render json: { error: 'Unauthorized' }, status: 401 unless user_signed_in?
    return render json: { error: 'Wrong format' }, status: 422 unless params[:id].is_a?(Integer) && params[:user_id].is_a?(Integer)
    property = Property.find_by(id: params[:id])
    user = User.find_by(id: params[:user_id])
    return render json: { error: 'This property is not found' }, status: 404 if property.nil?
    return render json: { error: 'This user is not found' }, status: 404 if user.nil?
    begin
      date_from = Date.parse(params[:date_from])
      date_to = Date.parse(params[:date_to])
    rescue ArgumentError
      return render json: { error: 'Invalid date format.' }, status: 400
    end
    return render json: { error: 'The start date cannot be after the end date.' }, status: 400 if date_from > date_to
    booking = Booking.create(user_id: user.id, listing_id: property.id, date_from: date_from, date_to: date_to)
    if booking.persisted?
      render json: { status: 200, message: 'Booking successfully created', booking: booking }, status: 200
    else
      render json: { error: 'Failed to create booking' }, status: 500
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
  private
  def booking_params
    params.require(:booking).permit(:id, :start_date, :end_date, :num_guests, :listing_id, :user_id, :date_from, :date_to)
  end
end
