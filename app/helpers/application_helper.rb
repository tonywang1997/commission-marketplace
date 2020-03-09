module ApplicationHelper

  def logged_in_actions
    return {users: [:edit, :update, :dashboard]}
  end

end
