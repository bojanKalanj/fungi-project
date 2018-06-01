class Admin::AdminController < ApplicationController
  layout "admin"
  
  include StandardResponses

  before_action :authenticate_user!
  check_authorization

  def show
    standard_nil_record_response(current_resource.class) if current_resource.nil?
  end

  def create
    standard_create_response current_resource, current_resource.save, fields: @fields
  end

  def edit
    standard_nil_record_response(current_resource.class) if current_resource.nil?
  end

  def update
    standard_update_response current_resource, current_resource.update(resource_params), fields: @fields
  end

  def destroy
    standard_destroy_response(current_resource, current_resource.destroy, source: params['source'])
  end

  def action
    action_name.to_sym
  end

  def current_resource
    raise 'Has to be overridden'
  end

  def resource_params
    raise 'Has to be overridden'
  end
end
