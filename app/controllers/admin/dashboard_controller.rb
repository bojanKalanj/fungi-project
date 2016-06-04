class Admin::DashboardController < ApplicationController

  before_action :authenticate_user!
  check_authorization

  def show
    authorize! :show, :dashboard
    @audits = Audit.order('created_at DESC').limit(10)
  end

end