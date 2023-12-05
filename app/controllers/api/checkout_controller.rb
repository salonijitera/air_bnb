class Api::CheckoutController < ApplicationController
  def create
    user_id = params[:user_id]
    total_amount = params[:total_amount]
    checkout_date = params[:checkout_date]
    status = params[:status]
    # Validate user_id
    unless User.exists?(user_id)
      return render json: { error: 'Invalid user id' }, status: 404
    end
    # Validate total_amount
    unless total_amount.is_a?(Float) || total_amount.is_a?(Integer)
      return render json: { error: 'Invalid total amount' }, status: 422
    end
    # Validate checkout_date
    begin
      DateTime.strptime(checkout_date, '%Y-%m-%d %H:%M:%S')
    rescue ArgumentError
      return render json: { error: 'Invalid checkout date' }, status: 422
    end
    # Validate status
    unless CheckoutInfo.statuses.include?(status)
      return render json: { error: 'Invalid status' }, status: 422
    end
    # Create new checkout_info
    checkout_info = CheckoutInfo.create(user_id: user_id, total_amount: total_amount, checkout_date: checkout_date, status: status)
    # Return confirmation message
    render json: { message: 'Checkout information successfully received and stored', checkout_info_id: checkout_info.id }, status: 200
  end
end
