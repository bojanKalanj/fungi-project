class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # Whitelisting deviseparams
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def configure_permitted_parameters
    registration_params = [:first_name, :last_name, :password, :email]

    if params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) do
        |u| u.permit(registration_params)
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { render nothing: true, status: :forbidden }
      format.json { render nothing: true, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end
end
