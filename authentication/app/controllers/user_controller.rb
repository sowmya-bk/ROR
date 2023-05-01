class UserController < ApplicationController
    skip_before_action :verify_authenticity_token
    def index
        @users = User.where(:role => 'user')
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(email: params["user[email]"])
        @user.save
        
        puts "################"
    end

    def edit
        
        @user=User.find(params[:id])
    end
    def update
        @user = User.find(params[:id])
        @user.email = params[:email]
        @user.firstname = params[:firstname]
        @user.lastname = params[:lastname]
        @user.username = params[:username]
        @user.role = params[:role]
        @user.phone_number = params[:phone_number]
        @user.update
        @user.save
        redirect_to users_path, notice: "User updated successfully"
    end
    private

    def user_params
        params.require(:user).permit(:email, :firstname, :lastname, :username, :role, :phone_number, :encrypted_password)
    end
end