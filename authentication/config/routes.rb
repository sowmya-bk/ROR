Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  post '/update/:id', to: "posts#update", as: 'update'
  resources :posts
  root "posts#index"
  get '/posts/:id/assignusers', to: "posts#users_assignment",as: 'assignusers'
  post '/posts/assignedusers', to: "posts#assigned_users"
  delete '/posts/:id/removeassigneduser',to: "posts#remove_assigned_user",as:'remove_assigned_user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
