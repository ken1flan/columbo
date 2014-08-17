class Admin::AdminController < ApplicationController
  before_filter :check_admin

  def check_admin
    not_found unless user_signed_in? && current_user.admin?
  end
end
