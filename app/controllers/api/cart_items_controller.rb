class Api::CartItemsController < ApplicationController
  before_action :authorize_request
  def create
    cart = Cart.find_by(id: params[:cart_id])
    product = Product.find_by(id: params[:product_id])
    return render json: { error: 'This cart is not found' }, status: :bad_request unless cart
    return render json: { error: 'This product is not found' }, status: :bad_request unless product
    return render json: { error: 'Quantity must be at least 1.' }, status: :unprocessable_entity if params[:quantity].to_i < 1
    cart_item = cart.cart_items.create(product: product, quantity: params[:quantity])
    if cart_item.persisted?
      render json: { status: 201, cart_item: cart_item }, status: :created
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  private
  def authorize_request
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user && current_user.cart.id == params[:cart_id].to_i
  end
end
