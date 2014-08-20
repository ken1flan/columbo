class Admin::ExcludedTwitterUsersController < ApplicationController
  before_action :set_excluded_twitter_user, only: [:show, :edit, :update, :destroy]

  # GET /excluded_twitter_users
  # GET /excluded_twitter_users.json
  def index
    @excluded_twitter_users = ExcludedTwitterUser.all
  end

  # GET /excluded_twitter_users/1
  # GET /excluded_twitter_users/1.json
  def show
  end

  # GET /excluded_twitter_users/new
  def new
    @excluded_twitter_user = ExcludedTwitterUser.new
  end

  # GET /excluded_twitter_users/1/edit
  def edit
  end

  # POST /excluded_twitter_users
  # POST /excluded_twitter_users.json
  def create
    @excluded_twitter_user = ExcludedTwitterUser.new(excluded_twitter_user_params)

    respond_to do |format|
      if @excluded_twitter_user.save
        format.html { redirect_to admin_excluded_twitter_user_path(id: @excluded_twitter_user.id), notice: 'Excluded twitter user was successfully created.' }
        format.json { render :show, status: :created, location: admin_excluded_twitter_user_path(id: @excluded_twitter_user.id) }
      else
        format.html { render :new }
        format.json { render json: @excluded_twitter_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /excluded_twitter_users/1
  # PATCH/PUT /excluded_twitter_users/1.json
  def update
    respond_to do |format|
      if @excluded_twitter_user.update(excluded_twitter_user_params)
        format.html { redirect_to @excluded_twitter_user, notice: 'Excluded twitter user was successfully updated.' }
        format.json { render :show, status: :ok, location: @excluded_twitter_user }
      else
        format.html { render :edit }
        format.json { render json: @excluded_twitter_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /excluded_twitter_users/1
  # DELETE /excluded_twitter_users/1.json
  def destroy
    @excluded_twitter_user.destroy
    respond_to do |format|
      format.html { redirect_to excluded_twitter_users_url, notice: 'Excluded twitter user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_excluded_twitter_user
      @excluded_twitter_user = ExcludedTwitterUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def excluded_twitter_user_params
      params.require(:excluded_twitter_user).permit(:uid, :name, :screen_name, :memo)
    end
end
