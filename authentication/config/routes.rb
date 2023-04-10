Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  post '/update/:id', to: "posts#update", as: 'update'
  resources :posts
  root "posts#index"
  get '/posts/:id/assign_users', to: "posts#users_assignment",as: 'assignusers'
  post '/posts/assignedusers', to: "posts#assigned_users",as:'user_assignment'
  patch '/posts/:id/removeassigneduser',to: "posts#remove_assigned_user",as:'remove_assigned_user'
  get '/sendmail',to:"posts#send_mail_to_user"
  get '/multiplemails', to:"posts#send_multiple_mails"
  require 'resque/server'
  require 'resque/scheduler/server'
  mount Resque::Server.new, at: "/resque"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
