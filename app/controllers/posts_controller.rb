class PostsController < ApplicationController
  include RolesHelper

  before_action :logged_in_user
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.includes(:user, :roles).order("created_at DESC")
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.roles = post_roles

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.includes(:user, :roles).find(params[:id])
    @roles = roles_to_hash(@post.roles)
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :deadline, :price, :content)
  end

  def post_roles
    roles = []
    if params[:roles]
      params[:roles].keys.each do |key|
        if key.to_i.to_s == key
          role_info = params[:roles][key]
          roles.push(Role.new({
            category: role_info[:category],
            name: role_info[:name],
            description: role_info[:description],
          }))
        end
      end
    end
    roles
  end

  def find_post
    @post = Post.find(params[:id])
  end

  
end
