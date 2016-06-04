class Admin::CharacteristicsController < Admin::AdminController
  include HabitatHelper

  before_action :set_species
  before_action :set_reference
  before_action :set_characteristic
  before_action :set_fields

  authorize_resource

  respond_to :js

  def self.index_fields_for(resource)
    fields = [(resource == :species ? { name: :reference, field: :full_title } : { name: :species, field: :full_name, class: 'italic' })]
    fields + [
      { name: :short, no_label: true, method: :short_characteristics },
      { name: :long, no_label: true, method: :long_characteristics },
      { name: :habitats, method: :habitat_icons },
      { name: :substrates, method: :substrate_icons },
      { name: :actions, no_label: true }
    ]
  end

  def index
  end

  def create
    if @characteristic.save
      @characteristics = @species ? @characteristic.species.characteristics : @characteristic.reference.characteristics
      render :index
    else
      puts @characteristic.errors.messages.inspect
      head :no_content
    end
  end

  def update
    if @characteristic.update(resource_params)
      flash.now[:message] = 'success'
      @characteristics = @species ? @characteristic.species.characteristics : @characteristic.reference.characteristics
      render :index
    else
      puts @characteristic.errors.messages.inspect
      head :no_content
    end
  end

  def destroy
    if @characteristic.destroy
      @characteristics = @species ? @characteristic.species.characteristics : @characteristic.reference.characteristics
      render :index
    else
      puts @characteristic.errors.messages.inspect
      head :no_content
    end

  end

  private

  def set_characteristic
    if action == :new
      @characteristic = @species ? @species.characteristics.new : @reference.characteristics.new
    elsif action == :create
      @characteristic = @species ? @species.characteristics.new(resource_params) : @reference.characteristics.new(resource_params)
    elsif action == :index
      @characteristics = @species ? @species.characteristics : @reference.characteristics
    else
      @characteristic = Characteristic.friendly.find(params[:id])
    end

    @characteristic.habitats = params['characteristic']['habitats'].values.uniq if params && params['characteristic'] && params['characteristic']['habitats']
    @characteristic.substrates = params['characteristic']['substrates'].reject! { |s| s.empty? } if params && params['characteristic'] && params['characteristic']['substrates']
  end

  def set_species
    @species = Species.where(url: params[:species_url]).first
  end

  def set_reference
    @reference = params[:reference_id] ? Reference.friendly.find(params[:reference_id]) : nil
  end

  def set_fields
    @options = {
      index_path: @species ? admin_species_characteristics_path(@species) : admin_reference_characteristics_path(@reference),
      new_path: @species ? new_admin_species_characteristic_path(@species) : new_admin_reference_characteristic_path(@reference),
      remote: true
    }

    unless [:index, :new, :create].include?(action)
      @options[:edit_path] = @species ? edit_admin_species_characteristic_path(@species, @characteristic) : edit_admin_reference_characteristic_path(@reference, @characteristic)
      @options[:path] = @species ? admin_species_characteristic_path(@species, @characteristic) : admin_reference_characteristic_path(@reference, @characteristic)
    end

    if [:index, :update, :create, :destroy].include?(action)
      @fields = Admin::CharacteristicsController.index_fields_for(@species ? :species : :reference)
    else
      @fields = [@species ? { name: :reference, field: :full_title, include_blank: false, as: :collection_select, collection: Reference.where.not(id: Characteristic.where(species_id: @species.id).pluck(:reference_id)) }
                 : { name: :species, field: :full_name, include_blank: false, as: :collection_select, label_method: :full_name, value_method: :id, collection: Species.where('id not in (?)', Characteristic.where(reference_id: @reference.id).pluck(:species_id)), input_html: { class: 'italic' } }]
      @fields += [
        { name: :edible, method: :boolean_to_icon },
        { name: :cultivated, method: :boolean_to_icon },
        { name: :poisonous, method: :boolean_to_icon },
        { name: :medicinal, method: :boolean_to_icon },
        { name: :habitats, method: :habitats_preview },
        { name: :substrates, method: :substrates_preview },
        { name: :fruiting_body, method: :localized_characteristic_preview },
        { name: :microscopy, method: :localized_characteristic_preview },
        { name: :flesh, method: :localized_characteristic_preview },
        { name: :chemistry, method: :localized_characteristic_preview },
        { name: :note, method: :localized_characteristic_preview }
      ]
    end
  end

  def resource_params
    params.require(:characteristic).permit(Characteristic::PUBLIC_FIELDS)
  end

  def current_resource
    @characteristic
  end
end
