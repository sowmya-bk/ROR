class UserController < ApplicationController
    skip_before_action :verify_authenticity_token
    def index
        @users = User.where(:role => 'user')
    end
    def edit
        @user=User.find(params[:id])
    end
    def update
        @user = User.find(params[:id])
        @user.email = params[:user_email]
        @user.firstname = params[:user_firstname]
        @user.lastname = params[:user_lastname]
        @user.username = params[:user_username]
        @user.role = params[:user_role]
        @user.save
        redirect_to users_path, notice: "User updated successfully"
    end
end