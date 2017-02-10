class UserMailer < ApplicationMailer
  default from: 'hello@yatrum.com'
  layout 'mailer'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Yatrum')
  end

end
