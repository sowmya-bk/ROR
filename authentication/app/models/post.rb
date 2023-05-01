class Post
  include Mongoid::Document
  include Mongoid::Timestamps 
  include CarrierWave::Mount
  field :title, type: String
  field :body, type: String
  field :post_created_user_id, type: String
  field :assigned_user_id, type: Array
  mount_uploaders :attachments, FileUploader
end
