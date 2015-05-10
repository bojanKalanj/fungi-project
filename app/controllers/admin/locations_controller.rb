class Admin::LocationsController < ApplicationController
  include StandardResponses

  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :set_location_fields, only: [:new, :edit, :update]
  before_action :authenticate_user!

  def index
    @locations = Location.all

    @location_fields = [
      { name: :name },
      { name: :utm },
      { name: :actions, no_label: true }
    ]
  end

  def show
    standard_nil_record_response(Location) if @location.nil?
  end

  def new
    @location = Location.new
  end

  def edit
    standard_nil_record_response(Location) if @location.nil?
  end

  def create
    @location = Location.new(location_params)
    standard_create_response @location, @location.save
  end

  def update
    standard_update_response @location, @location.update(location_params)
  end

  def destroy
    if @location.specimens.count > 0
      standard_destroy_response(@location, false, error: 'location.error.destroyed_has_specimens', source: params['source'])
    else
      standard_destroy_response(@location, @location.destroy, source: params['source'])
    end
  end

  private
  def set_location
    @location = Location.friendly.find(params[:id])
  rescue
    @location = nil
  end

  def set_location_fields
    @location_fields = [
      { name: :name },
      { name: :utm }
    ]
  end

  def location_params
    params.require(:location).permit(Location::PUBLIC_FIELDS)
  end
end