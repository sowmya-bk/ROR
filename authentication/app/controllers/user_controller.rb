class UserController < ApplicationController
    skip_before_action :verify_authenticity_token
    def index
        @users = User.where(:role => 'user')
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        @user.save
        if @user.save
            flash[:success] = "Successfully registered"
            redirect_to users_path
          else
            flash[:error] = "Cannot create an user, check the input and try again"
            render :new
            puts "aaaaaaaaaaaaaa"
        end
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
        @user.save
        redirect_to users_path, notice: "User updated successfully"
    end
    private

    def user_params
        params.require(:user).permit(:email, :firstname, :lastname, :username, :role, :phone_number, :encrypted_password)
    end
end