class Api::CheckoutInfoController < ApplicationController
  before_action :authenticate_user, only: [:update]
  before_action :set_checkout_info, only: [:update]
  before_action :validate_params, only: [:update]
  def update
    if @checkout_info.user_id != current_user.id
      render json: { error: 'Forbidden' }, status: :forbidden
    else
      if @checkout_info.update(checkout_info_params)
        render json: { message: 'Checkout info updated successfully', checkout_info: @checkout_info.as_json }, status: :ok
      else
        render json: { errors: @checkout_info.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  private
  def set_checkout_info
    @checkout_info = CheckoutInfo.find_by(id: params[:id])
    render json: { error: 'This checkout info is not found' }, status: :not_found if @checkout_info.nil?
  end
  def validate_params
    render json: { error: 'Wrong format' }, status: :bad_request unless params[:id].is_a?(Integer) && params[:user_id].is_a?(Integer) && params[:total_amount].is_a?(Float) && DateTime.parse(params[:checkout_date]) && params[:status].is_a?(String)
  rescue ArgumentError
    render json: { error: 'Wrong format' }, status: :bad_request
  end
  def checkout_info_params
    params.require(:checkout_info).permit(:user_id, :total_amount, :checkout_date, :status)
  end
end
