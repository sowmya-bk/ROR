class UserController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    def index
        @users = User.where(:role => 'user')
        authorize @users
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        puts @user
        if @user.save
            redirect_to users_path, notice: "user successfully created"
        else
            render :new
        end 
    end

    def edit
        
        @user=User.find(params[:id])
    end
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          redirect_to users_path, notice: "User updated successfully"
        else
            render :edit
        end
    end
    
    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_path, notice: "User deleted"
    end
    private

    def user_params
        params.require(:user).permit(:email, :firstname, :lastname, :username, :role, :phone_number, :password)
    end
end