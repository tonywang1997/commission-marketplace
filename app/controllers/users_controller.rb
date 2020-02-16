class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # handle successful save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
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
end
