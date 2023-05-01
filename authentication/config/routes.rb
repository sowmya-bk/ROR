Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  post '/update/:id', to: "posts#update", as: 'update'
  resources :posts
  root "posts#home"
  get '/posts/:id/assign_users', to: "posts#users_assignment",as: 'assignusers'
  post '/posts/assignedusers', to: "posts#assigned_users",as:'user_assignment'
  patch '/posts/:id/removeassigneduser',to: "posts#remove_assigned_user",as:'remove_assigned_user'
  get '/sendmail',to:"posts#send_mail_to_user"
  get '/multiplemails', to:"posts#send_multiple_mails"
  delete '/posts/deleteattachments/:id',to: "posts#delete_attachments",as:'delete_all_attachments'
  patch '/posts/removeattachment/:id',to: "posts#remove_attachment",as:'remove_attachment'
  post '/posts/update', to: "posts#add_attachments", as:'update_post'
  get '/users',to: "user#index", as:'users'
  get '/user/edit/:id', to: "user#edit", as:"user_edit"
  post '/user/update', to: "user#update", as:"user_update"
  get '/user/new', to: "user#new", as:"user_new"
  post '/user/create', to: "user#create", as:"user_create"
  delete '/user/delete/:id', to: "user#destroy", as:"user_delete"
  require 'resque/server'
  require 'resque/scheduler/server'
  mount Resque::Server.new, at: "/resque"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
