class CartItemsController < ApplicationController
  before_action :authenticate_user!
  def add_product_to_cart
    user_id = params[:user_id]
    product_id = params[:product_id]
    quantity = params[:quantity]
    # Check if the product exists
    unless Product.exists?(product_id)
      return render json: { error: 'Product not found' }, status: 404
    end
    # Check if the user already has a cart
    cart = Cart.find_by(user_id: user_id)
    unless cart
      # Create a new cart for the user
      cart = Cart.create(user_id: user_id)
    end
    # Add the product to the cart
    cart_item = CartItem.create(product_id: product_id, cart_id: cart.id, quantity: quantity)
    if cart_item.save
      render json: { status: 200, message: 'Product successfully added to cart', cart: cart }
    else
      render json: { error: 'Failed to add product to cart' }, status: 500
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
end
