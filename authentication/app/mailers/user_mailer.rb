class UserMailer < ApplicationMailer
    default from:'sowmya.b@lumiseek.com'

    layout "mailer"

    def email_to_user(user,comment)
        @user=user
        @comment=comment
        mail(to: @user,subject: 'email')
    end
end
