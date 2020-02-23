class HasTagsController < ApplicationController
  before_action :set_has_tag, only: [:show, :edit, :update, :destroy]

  # GET /has_tags
  # GET /has_tags.json
  def index
    @has_tags = HasTag.all
  end

  # GET /has_tags/1
  # GET /has_tags/1.json
  def show
  end

  # GET /has_tags/new
  def new
    @has_tag = HasTag.new
  end

  # GET /has_tags/1/edit
  def edit
  end

  # POST /has_tags
  # POST /has_tags.json
  def create
    @has_tag = HasTag.new(has_tag_params)

    respond_to do |format|
      if @has_tag.save
        format.html { redirect_to @has_tag, notice: 'Has tag was successfully created.' }
        format.json { render :show, status: :created, location: @has_tag }
      else
        format.html { render :new }
        format.json { render json: @has_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /has_tags/1
  # PATCH/PUT /has_tags/1.json
  def update
    respond_to do |format|
      if @has_tag.update(has_tag_params)
        format.html { redirect_to @has_tag, notice: 'Has tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @has_tag }
      else
        format.html { render :edit }
        format.json { render json: @has_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /has_tags/1
  # DELETE /has_tags/1.json
  def destroy
    @has_tag.destroy
    respond_to do |format|
      format.html { redirect_to has_tags_url, notice: 'Has tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_has_tag
      @has_tag = HasTag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def has_tag_params
      params.require(:has_tag).permit(:tag_id, :artist_id)
    end
end
