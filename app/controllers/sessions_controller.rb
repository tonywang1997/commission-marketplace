class SessionsController < ApplicationController
  def new
  end

  def create
    @user_name = params[:session][:user_name]
    user = User.find_by(user_name: params[:session][:user_name].downcase)
    if user && user.authenticate(params[:session][:password])
      # successful login
      log_in user
      redirect_to user_path(user.user_name)
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end