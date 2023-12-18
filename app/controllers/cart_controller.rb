class CartController < ApplicationController
  def add_product_to_cart(user_id, product_id, quantity)
    product = Product.find_by(id: product_id)
    return { error: 'Product not found' } unless product
    user = User.find_by(id: user_id)
    return { error: 'User not found' } unless user
    user.cart ||= Cart.create(user_id: user_id)
    CartItem.create(product_id: product_id, cart_id: user.cart.id, quantity: quantity)
    cart_info = user.cart.cart_items.includes(:product).map do |item|
      { product: item.product.name, quantity: item.quantity }
    end
    { cart: cart_info }
  end
end
