require 'resque'
require '/home/sowmya/ROR/authentication/app/jobs/bulk_mails.rb'
class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy]
  skip_before_action :verify_authenticity_token
  
  # GET /posts or /posts.json
  def home
  end


  def index
    @date=params[:date].present? ? params[:date].to_date : Time.now
    @checkbox=params[:box].present? ? params[:box] : 'weekmonth'
  
    if @checkbox.include?('week')
      start_date=@date.beginning_of_week
      end_date=@date.end_of_week
    else
      start_date=@date.beginning_of_month
      end_date=@date.end_of_month
    end
    pagenum = params[:page].present? ? params[:page] : "1"
    @posts=Post.where(:created_at => start_date..end_date).page(pagenum).per(5) 
    
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
    @post[:assigned_user_id]=@post[:assigned_user_id]-[params[:userid]]
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

  def delete_attachments
    @post = Post.find(params[:id])
    @post[:attachments].clear
    @post.save
    redirect_to post_path , notice: "Attachments Deleted"
  end

  def remove_attachment
    @post = Post.find(params[:id])
    @post[:attachments]-=[params[:file]]
    puts @post[:attachments]
    puts @post[:attachments][0]
    puts @post[:attachments][1]
    puts @post[:attachments][2]
    @post.save
    redirect_to edit_post_path
  end
  # GET /posts/1 or /posts/1.json
  def show
    if @post[:assigned_user_id].present?
      @users=@post[:assigned_user_id]
      @users=Kaminari.paginate_array(@users).page(params[:page]).per(2)
    end
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
      params.require(:post).permit(:title, :body, :post_created_user_id, assigned_user_id: params[:assigned_users],attachments: [])
    end
end