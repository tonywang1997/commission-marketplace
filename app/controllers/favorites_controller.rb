class FavoritesController < ApplicationController
  def update
    fave = Favorite.where(post: Post.find(params[:post]), user: current_user)
    if fave == [] 
      begin
        # when the current_user == nil, create will fail
        Favorite.create!(post: Post.find(params[:post]), user: current_user)
        @favorite_exists = true
      rescue
        respond_to do |format|
          format.js { flash.now[:notice] = "Failed to favorite. Please Log in!" }
        end
      end
    else
      fave.destroy_all
      @favorite_exists = false
    end
  end

end
