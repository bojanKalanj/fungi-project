class Admin::SpecimensController < ApplicationController
  include StandardResponses

  before_action :set_specimen, only: [:show, :edit, :update, :destroy]
  before_action :set_specimen_fields
  before_action :authenticate_user!

  def index
    @specimens = Specimen.includes(:species, :location).all

    @specimen_fields = [
      { name: :species, field: :full_name, class: 'italic no-wrap' },
      { name: :location, field: :name },
      { name: :date, method: :localize_date, options: { format: :long }, class: 'no-wrap' },
      { name: :habitat_title, class: 'no-wrap' },
      { name: :substrate_title },
      { name: :actions, no_label: true }
    ]
  end

  def show
    standard_nil_record_response(Specimen) if @specimen.nil?
  end

  def new
    @specimen = Specimen.new
  end

  def edit
    standard_nil_record_response(Specimen) if @specimen.nil?
  end

  def create
    @specimen = Specimen.new(specimen_params)
    standard_create_response @specimen, @specimen.save, fields: @specimen_fields
  end

  def update
    standard_update_response @specimen, @specimen.update(specimen_params), fields: @specimen_fields
  end

  def destroy
    standard_destroy_response(@specimen, @specimen.destroy, source: params['source'])
  end

  private
  def set_specimen
    @specimen = Specimen.friendly.find(params[:id])
  end

  def set_specimen_fields
    @specimen_fields = [
      { name: :species, field: :full_name, label_method: :full_name, value_method: :id, input_html: { class: 'italic' } },
      { name: :location, field: :name },
      { name: :legator, field: :full_name, label_method: :full_name, value_method: :id },
      { name: :determinator, field: :full_name, label_method: :full_name, value_method: :id },
      { name: :habitats },
      { name: :substrates },
      { name: :quantity, as: :string },
      { name: :note },
      { name: :approved },
      { name: :date, as: :string, input_html: { class: 'datepicker' }, method: :localize_date, options: { format: :long } }
    ]
  end

  def specimen_params
    params.require(:specimen).permit(Specimen::PUBLIC_FIELDS)
  end

end