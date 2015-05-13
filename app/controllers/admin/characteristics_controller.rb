class Admin::CharacteristicsController < Admin::AdminController

  before_action :set_species
  before_action :set_characteristic
  before_action :set_fields

  authorize_resource

  respond_to :js

  INDEX_FIELDS = [
    { name: :reference, field: :full_title },
    { name: :short, no_label: true, method: :short_characteristics },
    { name: :long, no_label: true, method: :long_characteristics },
    { name: :actions, no_label: true }
  ]

  def index
  end

  def create
    if @characteristic.save
      @characteristics = @characteristic.species.characteristics
      render :index
    else
      puts @characteristic.errors.messages.inspect
      head :no_content
    end
  end

  def update
    if @characteristic.update(resource_params)
      flash.now[:message] = 'success'
      @characteristics = @characteristic.species.characteristics
      render :index
    else
      puts @characteristic.errors.messages.inspect
      head :no_content
    end
  end

  def destroy
    if @characteristic.destroy
      @characteristics = @characteristic.species.characteristics
      render :index
    else
      puts @characteristic.errors.messages.inspect
      head :no_content
    end

  end

  private
  def set_characteristic
    if action == :new
      @characteristic = @species.characteristics.new
    elsif action == :create
      @characteristic = @species.characteristics.new(resource_params)
    elsif action == :index
      @characteristics = @species.characteristics
    else
      @characteristic = Characteristic.friendly.find(params[:id])
    end
  end

  def set_species
    @species = Species.where(url: params[:species_url]).first
    # @species = @characteristic.species
  end

  def set_fields
    @options = {
      index_path: admin_species_characteristics_path(@species),
      new_path: new_admin_species_characteristic_path(@species),
      remote: true
    }

    unless [:index, :new, :create].include?(action)
      @options[:edit_path] = edit_admin_species_characteristic_path(@species, @characteristic)
      @options[:path] = admin_species_characteristic_path(@species, @characteristic)
    end

    if [:index, :update, :create, :destroy].include?(action)
      @fields = INDEX_FIELDS
    else
      @fields = [
        { name: :reference, field: :full_title, include_blank: false, as: :collection_select, collection: Reference.where('id not in (?)', Characteristic.where(species_id: @species.id).pluck(:reference_id)) },
        { name: :edible, method: :boolean_to_icon },
        { name: :cultivated, method: :boolean_to_icon },
        { name: :poisonous, method: :boolean_to_icon },
        { name: :medicinal, method: :boolean_to_icon },
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
