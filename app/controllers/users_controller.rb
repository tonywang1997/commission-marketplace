class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

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
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # handle successful save
      flash[:success] = "Welcome to the Commission Marketplace!"
      log_in @user
      redirect_to user_path(@user.user_name)
    else
      render 'new'
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
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by(user_name: params[:user_name])
      redirect_to(edit_user_url(current_user)) unless @user == current_user
    end
end
