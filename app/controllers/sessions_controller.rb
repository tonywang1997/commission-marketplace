class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.html {
        flash[:misc_params] = { show_login: true }
        redirect_to root_url
      }
      format.js
    end
  end

  def create
    @user_name = params[:session][:user_name]
    user = User.find_by(user_name: params[:session][:user_name].downcase)
    if user && user.authenticate(params[:session][:password])
      # successful login
      log_in user
      respond_to do |format|
        format.html { redirect_to user_path(user.user_name) }
        format.js
      end
    else
      @error = "Invalid username/password combination."
      respond_to do |format|
        format.html { render 'new' }
        format.js { render 'create_error' }
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
