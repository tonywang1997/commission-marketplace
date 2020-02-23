class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :dashboard]
  before_action :correct_user, only: [:edit, :update]
  layout :resolve_layout

  def show
    @user = User.find_by(user_name: params[:user_name])
  end

  def edit
  end

  def dashboard
    @user = current_user
    render 'edit'
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

  private
    def user_params
      # raise an error if :user is not an attribute of params hash
      # return hash with attributes :user_name, :email_address, :password, :password_confirmation
      params.require(:user).permit(:user_name, :email_address, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by(user_name: params[:user_name])
      if @user != current_user
        redirect_to root_url
      end
    end

    def resolve_layout
      case action_name
      when "new"
        "no-header"
      else
        "application"
      end
    end
end
