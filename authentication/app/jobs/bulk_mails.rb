require 'resque'
class BulkMails
    Rails.logger.info "MAILS COUNT ------------------------------------------------"
    @queue = :mails_queue
    def self.perform(mails_array = [],comment = "HO")
        for i in 0...mails_array.length
          @mail = mails_array[i]
          @comment=comment
          BulkMailer.sending_multiple_emails_with_comment(@mail,@comment).deliver_now
        end
    end
end