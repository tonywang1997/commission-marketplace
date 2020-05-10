class FavoritesController < ApplicationController
  def update
    fave = Favorite.where(post: Post.find(params[:post]), user: current_user)
    if fave == [] 
      Favorite.create(post: Post.find(params[:post]), user: current_user)
      @favorite_exists = true
    else
      fave.destroy_all
      @favorite_exists = false
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

end
