class Admin::DashboardController < ApplicationController

  before_action :authenticate_user!
  check_authorization

  def show
    authorize! :show, :dashboard
  end

end