class Admin::SpeciesController < Admin::AdminController

  before_action :set_species
  before_action :set_species_fields

  authorize_resource

  def destroy
    if @species.specimens.count > 0
      standard_destroy_response(@species, false, error: 'species.error.destroyed_has_specimens', source: params['source'])
    else
      standard_destroy_response(@species, @species.destroy, source: params['source'])
    end
  end

  private

  def set_species
    if action == :new
      @species = Species.new
    elsif action == :create
      @species = Species.new(resource_params)
    elsif action == :index
      @species = Species.all
    else
      @species = Species.where(url: params[:url]).first
    end
  end

  def set_species_fields
    if action == :index
      @fields = [
        { name: :full_name, class: 'italic' },
        { name: :familia },
        { name: :growth_type },
        { name: :nutritive_group },
        { name: :actions, no_label: true }
      ]
    else
      @fields = [
        { name: :name, input_html: { class: 'italic' } },
        { name: :genus },
        { name: :familia },
        { name: :ordo },
        { name: :subclassis },
        { name: :classis },
        { name: :subphylum },
        { name: :phylum },
        { name: :synonyms, as: :string },
        { name: :growth_type },
        { name: :nutritive_group },
        { name: :square_pic }
      ]
      if action == :show
        @characteristic_fields = Admin::CharacteristicsController.index_fields_for(:species)

        @subheader_options = {
          new_path: new_admin_species_characteristic_path(@species),
          edit_path: edit_admin_species_characteristic_path(@species, @species.characteristics),
          path: admin_species_characteristic_path(@species, @species.characteristics),
          remote: true
        }
      end
    end
  end

  def resource_params
    params.require(:species).permit(Species::PUBLIC_FIELDS)
  end

  def current_resource
    @species
  end
end
