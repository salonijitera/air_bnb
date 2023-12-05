class LocalExperiencesMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def local_experience_updated(local_experience)
    @local_experience = local_experience
    mail(to: @local_experience.user.email, subject: 'Local Experience Updated')
  end
end
