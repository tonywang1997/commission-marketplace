class UsersController < ApplicationController
  include ApplicationHelper
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find_by(user_name: params[:user_name])
  end

  def edit
  end

  def dashboard
    @user = current_user
    @portfolios = []
    @user.portfolios.each do |portfolio|
      if portfolio.files.length > 0
        @portfolios << portfolio
      end
    end
    render 'dashboard'
  end

  def submit
  end

  def new
    respond_to do |format|
      format.html {
        flash[:misc_params] = { show_register: true }
        redirect_to root_url
      }
      format.js
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # handle successful save
      log_in @user
      respond_to do |format|
        format.html { 
          flash[:success] = "Welcome to the Commission Marketplace!"
          redirect_to user_path(@user.user_name)
        }
        format.js
      end
    else
      respond_to do |format|
        format.html {
          render 'new'
        }
        format.js { render :action => 'create_error' }
      end
    end
  end

  def avatar
    @user = current_user
    # set a placeholder for password, otherwise
    # the record's password validation fails when
    # hashed as a foreign key in the active storage
    @user.password = "placeholder"
    @user.avatar.attach(params[:user][:avatar])
    if @user.save
      head 200, content_type: "text/html"
    else
      render @user.errors.full_messages, :status => 500
    end
  end

  private
    def user_params
      # raise an error if :user is not an attribute of params hash
      # return hash with attributes :user_name, :email_address, :password, :password_confirmation
      params.require(:user).permit(:user_name, :email_address, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find_by(user_name: params[:user_name])
      if @user != current_user
        redirect_to root_url
      end
    end
end
