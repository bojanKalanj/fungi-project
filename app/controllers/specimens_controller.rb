class SpecimensController < ApplicationController
  include HabitatHelper

  before_action :clean_params, only: :search
  before_action :set_specimen_fields

  def index
    @specimens = Specimen.order("created_at DESC").paginate(:page => params[:page], per_page: 12 )
  end

  def show
    @specimen = Specimen.friendly.find(params[:id])
  end

  def new
    @specimen = Specimen.new
    authorize! :read, @specimen
  end

  def create
    @specimen = Specimen.new(resource_params)
    if @specimen.save
      redirect_to root_path
      flash[:notice] = "Successfully created..."
    else
      redirect_to root_path
      flash[:danger] = "Ne valja ti poso"
    end
  end

  def destroy
    @specimen = Specimen.friendly.find(params[:id])
    if @specimen.delete
      redirect_to root_path
      flash[:notice] = "Uzorak je obrisan"
    else
      redirect_to root_path
      flash[:danger] = "Neuspesno brisanje uzorka"
    end
  end

  def search
    species = Species.with_systematics(params[:s]).with_nutritive_group(params[:ng]).with_growth_type(params[:gt])

    species = species.where(id: species_ids_for_characteristics(species)).paginate(:page => params[:page])

    if params[:h].blank?
      @subhabitats = nil
      @habitat_species = nil
    else
      subhabitat_keys = subhabitat_keys(params[:h])
      @subhabitats = subhabitat_keys.map { |key| [t("habitats.#{params[:h]}.subhabitat.#{key}.title"), key] } unless subhabitat_keys.blank?

      habitat_species_keys = allowed_species(params[:h], params[:sh])
      @habitat_species = habitat_species_keys.map { |key| [localized_habitat_species_name(key), key] } unless habitat_species_keys.blank?
    end

    @specimens = Specimen.includes(:species).paginate(:page => params[:page]).where(species_id: species.pluck(:id))

    @params = params
  end

  private

  def set_specimen_fields
    if params[:action] == :index
      @fields = [
        { name: :species, field: :full_name, class: 'italic no-wrap' },
        { name: :location, field: :name },
        { name: :date, method: :localize_date, options: { format: :long }, class: 'no-wrap' },
        { name: :habitat, method: :habitat_icons },
        { name: :substrate, method: :substrate_icons },
        { name: :actions, no_label: true }
      ]
    else
      @fields = [
        { name: :species, field: :full_name, label_method: :full_name, value_method: :id, input_html: { class: 'italic' } },
        { name: :location, field: :name },
        { name: :legator, field: :full_name, label_method: :full_name, value_method: :id },
        { name: :determinator, field: :full_name, label_method: :full_name, value_method: :id },
        { name: :habitat, method: :habitat_title },
        { name: :substrate, method: :subhabitat_title, collection: all_substrate_keys.map{ |key| [t("substrates.#{key}"), key]}, label_method: :first, value_method: :last },
        { name: :quantity, as: :string },
        { name: :note },
        { name: :approved },
        { name: :date, as: :string, input_html: { class: 'datepicker' }, method: :localize_date, options: { format: :long } }
      ]
    end
  end

  def species_ids_for_characteristics(species)
    species_ids = species.pluck(:id)

    base_characteristics = Characteristic.where(species_id: species_ids)

    species_ids = base_characteristics.with_habitat(params).pluck(:species_id) &
      base_characteristics.with_substrate(params).pluck(:species_id) unless species_ids.blank?

    Characteristic::FLAGS.each do |flag|
      species_ids = species_ids & base_characteristics.where(flag => true).pluck(:species_id) if params[flag] && !species_ids.blank?
    end

    species_ids
  end

  def clean_params
    params.keys.each do |key|
      params[key] = nil if params[key].blank?
    end
  end

  def resource_params
    params.require(:specimen).permit(Specimen::PUBLIC_FIELDS)
  end
end
