class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  def booking_confirmation(booking)
    @booking = booking
    @user = booking.user
    mail(to: @user.email, subject: 'Booking Confirmation')
  end
end
