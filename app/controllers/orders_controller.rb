class OrdersController < ApplicationController
  before_action :authenticate_user!
  def create
    user = User.find(params[:user_id])
    cart = CartService.get_cart(user)
    cart_items = CartService.get_cart_items(cart)
    if cart_items.empty?
      render json: { error: 'Cart is empty' }, status: 400
      return
    end
    total_price = CartService.calculate_total_price(cart_items)
    order = OrderService.create_order(user, total_price)
    OrderService.move_items_to_order(cart_items, order)
    CartService.clear_cart(cart)
    EmailService.send_order_confirmation(user, order)
    @order = OrderService.get_order_details(order)
    render :show
  end
  private
  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: 401 unless user_signed_in?
  end
end
