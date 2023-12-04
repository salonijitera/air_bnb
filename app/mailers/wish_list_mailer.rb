class WishListMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def wish_list_created(wish_list)
    @wish_list = wish_list
    @user = @wish_list.user
    @url  = wish_list_url(@wish_list)
    mail(to: @user.email, subject: 'Wish List Created', body: "Your wish list #{@wish_list.name} has been created successfully.")
  end
end
