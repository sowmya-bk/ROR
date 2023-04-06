require "resque/tasks"
require '/home/sowmya/ROR/authentication/app/jobs/bulk_mails.rb'
task "resque:setup" => :environment