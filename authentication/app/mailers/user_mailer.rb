class UserMailer < ApplicationMailer
    default from:'myapp@xample.com'
    def email_to_user(user,comment)
        @user=user
        @comment=comment
        mail(to: @user.email)
    end
end
