require 'resque'
require '/home/sowmya/ROR/authentication/app/jobs/bulk_mails.rb'
class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy]
  skip_before_action :verify_authenticity_token
  
  # GET /posts or /posts.json
  def index
    if params[:date] == nil
      @date = Time.now
    else
      @date = params[:date].to_date
    end
    @posts=Post.where(:created_at => @date.beginning_of_month..@date.end_of_month , :created_at => @date.beginning_of_week..@date.end_of_week)
    respond_to do |format|
      format.html
      format.js {render layout:false}
    end
  end
  def users_assignment
    @post=Post.find(params[:id])
    @users=Array.new
    index=0
    User.each do |user|
      if user!= current_user
        @users[index]=user.id
        index= index+1
      end
    end
  end
  def assigned_users
    @assigned_users = Array.new
    @assigned_users = params[:assigned_users]
    @post = Post.find(params[:postid])
    if @post[:assigned_user_id] == nil
      @post[:assigned_user_id] = @assigned_users
    else
      @post[:assigned_user_id]=@post[:assigned_user_id]+@assigned_users
    end
    @post.save
    redirect_to root_path, notice: "User Successfully assigned."
  end
  def remove_assigned_user
    @post=Post.find(params[:id])
    @assigned_users_array=Array.new
    @assigned_users_array[0]=params[:userid]
    @post[:assigned_user_id]=@post[:assigned_user_id]-@assigned_users_array
    puts @post[:assigned_user_id]
    @post.save
    redirect_to root_path, notice: "User Successfully removed."

  end
  def send_mail_to_user
    @user = params[:user_email]
    @comment=params[:comment]
    UserMailer.sending_email_with_comment(@user,@comment).deliver_now
    redirect_to root_path
  end
  def send_multiple_mails
    
    @users_array=eval(params[:users])    
    @comment=params[:comment]
    @user_mails=Array.new
    for i in 0...@users_array.length
      @user=User.find(@users_array[i])
      @user_mails.append(@user.email)
    end
    puts "***************************"
    Resque.enqueue(BulkMails,@user_mails,@comment)
    puts "***************************"
    redirect_to root_path

  end
  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit 
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :post_created_user_id, assigned_user_id: params[:assigned_users])
    end
end