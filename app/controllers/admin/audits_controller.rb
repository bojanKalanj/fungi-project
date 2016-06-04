class Admin::AuditsController < Admin::AdminController

  authorize_resource

  def index
    @audits = Audit.order('created_at desc').limit(300)
  end

  def show
    @audit = Audit.where(id: params[:id]).first
  end
end
