namespace :assignuserrole_task do
    desc 'Assigning role to the existing users'
    task assign_role_to_existing_users: :environment do
        User.each do |user|
          user.role = :user
          user.save
        end
    end
end