class Admin::SpecimensController < Admin::AdminController

  before_action :set_specimen
  before_action :set_specimen_fields

  authorize_resource

  private
  
  def set_specimen
    if action == :new
      @specimen = Specimen.new
    elsif action == :create
      @specimen = Specimen.new(resource_params)
    elsif action == :index
      @specimens = Specimen.includes(:species, :location).all
    else
      @specimen = Specimen.friendly.find(params[:id])
    end
  end

  def set_specimen_fields
    if action == :index
      @fields = [
        { name: :species, field: :full_name, class: 'italic no-wrap' },
        { name: :location, field: :name },
        { name: :date, method: :localize_date, options: { format: :long }, class: 'no-wrap' },
        { name: :habitat_title, class: 'no-wrap' },
        { name: :substrate_title },
        { name: :actions, no_label: true }
      ]
    else
      @fields = [
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
  end

  def resource_params
    params.require(:specimen).permit(Specimen::PUBLIC_FIELDS)
  end

  def current_resource
    @specimen
  end
end