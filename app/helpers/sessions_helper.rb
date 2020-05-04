module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_user
    if logged_in_actions[params[:controller].to_sym] and 
      logged_in_actions[params[:controller].to_sym].include? params[:action].to_sym
      unless logged_in?
        redirect_back fallback_location: root_url, flash: { danger: 'Please log in.' }
      end
    end
  end

  def logged_in_actions
    return {
      posts: [:new, :edit, :create],
      users: [:edit, :update, :dashboard],
      portfolios: [:new, :edit, :create],
    }
  end
end
