class WishListMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def share_wish_list_email(user, wish_list)
    @user = user
    @wish_list = wish_list
    @url  = wish_list_url(@wish_list)
    mail(to: @user.email, subject: 'Shared Wish List')
  end
end
