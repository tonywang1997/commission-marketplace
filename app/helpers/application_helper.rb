module ApplicationHelper

  def logged_in_actions
    return {users: [:edit, :update, :dashboard],
            portfolios: [:new, :edit, :show, :create, :index]}
  end

end
