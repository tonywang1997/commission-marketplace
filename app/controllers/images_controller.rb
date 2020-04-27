class ImagesController < ApplicationController
    def favorite
        type = params[:type]
        if type == "favorite"
            current_user.favorites << @image
            redirect_to :back
        elsif type == "disfavor"
            current_user.favorites.delete(@image)
            redirect_to :back
        end
        redirect_to :back
    end
end
