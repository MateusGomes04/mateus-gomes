class UserMailer < ApplicationMailer
  default from: 'no-reply@seusite.com'

  def confirmation_email
    @user = params[:user]
    @url  = confirm_users_url(token: @user.confirmation_token)
    mail(to: @user.email, subject: 'Confirme sua conta')
  end
end
