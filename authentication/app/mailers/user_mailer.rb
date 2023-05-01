class UserMailer < ApplicationMailer
    default from:'sowmyabk38@gmail.com'

    layout "mailer"

    def sending_email_with_comment(user,comment)
        @user_mail=user
        @mail_comment=comment
        mail(
            :from =>"sowmyabk38@gmail.com", 
            :to => "#{@user_mail}", 
            :subject => "email"
        )
    end
end
