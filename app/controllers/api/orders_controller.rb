class Api::OrdersController < ApplicationController
  before_action :authorize, only: [:create]
  def create
    user = User.find_by(id: params[:user_id])
    if user.nil?
      render json: { error: 'This user is not found' }, status: :bad_request
    elsif current_user != user
      render json: { error: 'Forbidden' }, status: :forbidden
    else
      order = user.orders.build(order_params)
      if order.save
        render json: { status: :created, order: { id: order.id, user_id: order.user_id, total_price: order.total_price, status: order.status } }, status: :created
      else
        render json: { error: 'Internal Server Error' }, status: :internal_server_error
      end
    end
  end
  private
  def order_params
    params.require(:order).permit(:total_price, :status)
  end
end
