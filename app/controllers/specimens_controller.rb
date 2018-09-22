class SpecimensController < ApplicationController
  include HabitatHelper

  before_action :set_specimen
  before_action :clean_params, only: :search
  before_action :set_specimen_fields

  # authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    @specimen.legator_text = set_legator(@specimen.legator_id)
    @specimen.determinator_text = set_determinator(@specimen.determinator_id)

    if @specimen.save
      redirect_to root_path
      flash[:notice] = "Successfully created..."
    else
      redirect_to root_path
      flash[:danger] = "Ne valja ti poso"
    end
  end

  def edit
  end

  def update
    if @specimen.update_attributes(resource_params)
      redirect_to specimen_path(@specimen)
      flash[:notice] = "Successfully updated..."
    else
      flash[:danger] = "Ne valja ti poso"
    end
  end

  def destroy
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

  def set_specimen
    if params[:action] == 'new'
      @specimen = Specimen.new
    elsif params[:action] == 'create'
      @specimen = Specimen.new(resource_params)
    elsif params[:action] == 'index'
      @specimens = Specimen.order("created_at DESC").paginate(:page => params[:page], per_page: 12 )
    else
      @specimen = Specimen.friendly.find(params[:id])
    end

    @specimen.habitat = params['specimen']['habitat'] if params && params['specimen'] && params['specimen']['habitat']
  end

  def set_specimen_fields
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

  def set_legator(legator_id)
    User.find(legator_id).full_name
  end

  def set_determinator(determinator_id)
    User.find(determinator_id).full_name
  end

end
