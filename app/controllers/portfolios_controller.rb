require_relative '../helpers/img'

class PortfoliosController < ApplicationController
  include ApplicationHelper
  include SessionsHelper
  before_action :logged_in_user
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  # /storefront/:user_id
  def index
    @user ||= User.find_by(id: session[:user_id])
    @user_portfolios = @user.portfolios
    
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
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
    portfolio_files[:files].each do |blob|
      image = Image.new(file: blob)
      image.binary_matrix = MessagePack.pack(Img.new(blob.to_io, io: true).sample_self(128))
      @portfolio.images.push(image)
    end
    @portfolio.user_id = session[:user_id]

    respond_to do |format|
      if @portfolio.save
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
        :description, 
        :price_low,
        :price_high,
        files: [],
        tags_attributes: [:tag_name])
    end

    def portfolio_files
      params.require(:portfolio).permit(files: [])
    end

    def logged_in_user
      if logged_in_actions[:portfolios].include? params[:action].to_sym
        unless logged_in?
          redirect_to login_url
        end
      end
    end
end
