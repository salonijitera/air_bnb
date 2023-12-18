class OrderMailer < ApplicationMailer
  default from: 'no-reply@yourwebsite.com'
  def order_confirmation(order)
    @order = order
    @user = order.user
    @order_items = order.order_items.includes(:product)
    mail(to: @user.email, subject: 'Order Confirmation') do |format|
      format.html { render 'order_confirmation' }
    end.deliver_now
  end
end
