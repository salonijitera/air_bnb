class Api::ListingsController < ApplicationController
  before_action :authenticate_user!, only: [:book]
  def index    
    @listings = bounds ? Listing.in_bounds(bounds).with_attached_thumbnails.with_attached_photos.includes(:reviews) : Listing.all.with_attached_thumbnails.with_attached_photos.includes(:reviews)
    if @listings
      render :index  
    else
      render json: ["Listings not found!"], status: 422
    end
  end
  def show
    @listing = Listing.with_attached_thumbnails.with_attached_photos.includes(:reviews).includes(:reviewers).find_by(id: params[:id])
    if @listing
      render :show
    else
      render json: ["Listing not found!"], status: 422
    end
  end
  def book
    id = params[:id].to_i
    user_id = params[:user_id].to_i
    unless id.is_a?(Integer) && user_id.is_a?(Integer)
      render json: { error: "Wrong format" }, status: 422
      return
    end
    begin
      booking = Booking.create!(property_id: id, user_id: user_id)
      render json: { status: 200, message: "Property was successfully booked." }, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
  private
  def listing_params
    params.require(:listing).permit(:title, :description, :num_guests, :listing_type, :num_beds, :num_baths, :price, :self_check_in, :parking, :kitchen, :washer, :dryer, :dishwasher, :wifi, :tv, :bathroom_essentials, :bedroom_comforts, :coffee_maker, :hair_dryer, :location, :location_description, :lat, :long, :host_id, photos: [], thumbnails: [])
  end
  def bounds
    params[:bounds]
  end
  def user_id
    params[:user_id]
  end
end
