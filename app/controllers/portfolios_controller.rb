require_relative '../helpers/img'

class PortfoliosController < ApplicationController
  include ApplicationHelper
  include SessionsHelper
  before_action :logged_in_user
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  # /storefront?user_id=1
  def index
    @user ||= User.find(params[:user_id])
    # invalid user_id
    if @user == nil
      render "The user is not found", :status => 404
    end
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
    portfolio = Portfolio.find(params[:id])
    @images = portfolio.images
    if params[:img_id] != nil
      img_id = params[:img_id].to_i
      # puts the img_id in the first of portfolio images
      target_idx = find_target_idx(@images, img_id)
      # swap the first with img_idx
      @images = @images.to_a
      @images[0], @images[target_idx] = @images[target_idx], @images[0]
    end
  end

  # GET /submit
  def new
    @portfolio = Portfolio.new
    # create an empty tag child shown to the user
    1.times { @portfolio.tags.build }
  end

  # GET /portfolios/1/edit
  def edit
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = Portfolio.new(portfolio_params)
    image_ids = []
    portfolio_files[:files].each_with_index do |blob, idx|
      image = Image.new(file: blob)
      price = params["img-#{idx}-price".to_sym]
      image.price = price
      image.date = Time.now
      @portfolio.images.push(image)
    end
    @portfolio.user_id = session[:user_id]

    respond_to do |format|
      if @portfolio.save
        AnalyzeImagesJob.perform_later @portfolio.images.pluck(:id)
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully created.' }
        format.json { render :show, status: :created, location: @portfolio }
      else
        format.html { render :new }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portfolios/1
  # PATCH/PUT /portfolios/1.json
  def update
    respond_to do |format|
      if @portfolio.update(portfolio_params)
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully updated.' }
        format.json { render :show, status: :ok, location: @portfolio }
      else
        format.html { render :edit }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    @portfolio.destroy
    respond_to do |format|
      format.html { redirect_to portfolios_url, notice: 'Portfolio was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portfolio
      @portfolio = Portfolio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def portfolio_params
      params.require(:portfolio).permit(
        :title,
        :description, 
        :price_low,
        :price_high,
        tags_attributes: [:tag_name])
    end

    def portfolio_files
      params.require(:portfolio).permit(files: [])
    end

    def find_target_idx(images, img_id)
      images.each_with_index do |img, idx|
        if img.id == img_id
          return idx
        end
      end
      return -1
    end
end
