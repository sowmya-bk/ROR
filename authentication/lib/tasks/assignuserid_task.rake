namespace :assignuserid_task do
    desc 'Assigning post created user_id to the existing posts'
    task assign_userid_to_existing_posts: :environment do
        Post.each do |post|
            if post.post_created_user_id == nil
                post.post_created_user_id = User.first.id
                post.save
            end
        end
    end
end