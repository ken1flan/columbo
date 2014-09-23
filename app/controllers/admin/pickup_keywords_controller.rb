class Admin::PickupKeywordsController < Admin::AdminController
  before_action :set_pickup_keyword, only: [:show, :edit, :update, :destroy]

  # GET /admin/pickup_keywords
  # GET /admin/pickup_keywords.json
  def index
    @pickup_keywords = PickupKeyword.all
  end

  # GET /admin/pickup_keywords/1
  # GET /admin/pickup_keywords/1.json
  def show
  end

  # GET /admin/pickup_keywords/new
  def new
    @pickup_keyword = PickupKeyword.new
  end

  # GET /admin/pickup_keywords/1/edit
  def edit
  end

  # POST /admin/pickup_keywords
  # POST /admin/pickup_keywords.json
  def create
    @pickup_keyword = PickupKeyword.new(pickup_keyword_params)

    respond_to do |format|
      if @pickup_keyword.save
        format.html { redirect_to [:admin, @pickup_keyword], notice: 'Excluded twitter user was successfully created.' }
        format.json { render :show, status: :created, location: admin_pickup_keyword_path(id: @pickup_keyword.id) }
        format.js { render :create }
      else
        format.html { render :new }
        format.json { render json: @pickup_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/pickup_keywords/1
  # PATCH/PUT /admin/pickup_keywords/1.json
  def update
    respond_to do |format|
      if @pickup_keyword.update(pickup_keyword_params)
        format.html { redirect_to [:admin, @pickup_keyword], notice: 'Excluded twitter user was successfully updated.' }
        format.json { render :show, status: :ok, location: @pickup_keyword }
      else
        format.html { render :edit }
        format.json { render json: @pickup_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/pickup_keywords/1
  # DELETE /admin/pickup_keywords/1.json
  def destroy
    @deleted_pickup_keyword = @pickup_keyword.dup
    @pickup_keyword.destroy
    respond_to do |format|
      format.html { redirect_to admin_pickup_keywords_url, notice: 'Excluded twitter user was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render :destroy }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pickup_keyword
    @pickup_keyword = PickupKeyword.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pickup_keyword_params
    params.require(:pickup_keyword).permit(:pickup_keyword, :slug)
  end
end
