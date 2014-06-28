class UsersController < ApplicationController
  before_filter :get_user

  def show
  end

  def edit
  end

  def update
    @user.attributes = user_params
    if @user.save
      flash[:notice] = '保存しました'
      redirect_to :action => :show
    else
      flash[:error] = '保存に失敗しました'
      render :action => :edit
    end
  end

  private
    def get_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:name)
    end
end
