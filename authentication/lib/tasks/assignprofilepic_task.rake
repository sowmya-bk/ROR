require 'open-uri'
namespace :assignprofilepic_task do
    desc 'Assigning profile picture to the existing users'
    task assign_profile_to_existing_users: :environment do
        User.each do |user|
            user.image = open("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg")
            user.save
        end
    end
end