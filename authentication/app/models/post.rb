class Post
  include Mongoid::Document
  field :title, type: String
  field :body, type: String
  field :username, type: String
end
