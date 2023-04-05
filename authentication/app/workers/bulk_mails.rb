class BulkMails
    @queue = :mails_queue
    def self.perform(mails_array,comment)
        mails_array.each do |mail|
            @mail = mail
            @comment=comment
            BulkMailer.sending_multiple_emails_with_comment(@mail,@comment).deliver_now
        end
    end
end