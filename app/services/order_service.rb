class OrderService
  def place_order(user_id)
    user = User.find_by(id: user_id)
    return { error: 'User not found' } unless user
    cart = user.cart
    return { error: 'No items in cart' } unless cart.cart_items.any?
    total_price = cart.cart_items.sum { |item| item.product.price * item.quantity }
    order = user.orders.create(total_price: total_price, status: 'pending')
    cart.cart_items.each do |item|
      order.order_items.create(product: item.product, quantity: item.quantity)
      item.destroy
    end
    OrderMailer.with(user: user, order: order).confirmation.deliver_now
    order_info = {
      products: order.order_items.map { |item| { name: item.product.name, quantity: item.quantity } },
      total_price: order.total_price,
      status: order.status
    }
    order_info
  end
end
