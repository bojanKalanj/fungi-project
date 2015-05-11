class Admin::LocationsController < Admin::AdminController

  before_action :set_location
  before_action :set_location_fields

  authorize_resource

  def destroy
    if @location.specimens.count > 0
      standard_destroy_response(@location, false, error: 'location.error.destroyed_has_specimens', source: params['source'])
    else
      standard_destroy_response(@location, @location.destroy, source: params['source'])
    end
  end

  private
  
  def set_location
    if action == :new
      @location = Location.new
    elsif action == :create
      @location = Location.new(resource_params)
    elsif action == :index
      @locations = Location.all
    else
      @location = Location.friendly.find(params[:id])
    end
  end

  def set_location_fields
    if action == :index
      @fields = [
        { name: :name },
        { name: :utm },
        { name: :actions, no_label: true }
      ]
    else
      @fields = [
        { name: :name },
        { name: :utm }
      ]
    end
  end

  def resource_params
    params.require(:location).permit(Location::PUBLIC_FIELDS)
  end

  def current_resource
    @location
  end
end