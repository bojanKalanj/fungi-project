class Admin::SpeciesController < ApplicationController
  include StandardResponses

  before_action :set_species, only: [:show, :edit, :update, :destroy]
  before_action :set_species_fields
  before_action :authenticate_user!

  def index
    @species = Species.all

    @species_fields = [
      { name: :full_name, class: 'italic' },
      { name: :familia },
      { name: :growth_type },
      { name: :nutritive_group },
      { name: :actions, no_label: true }
    ]
  end

  def show
    standard_nil_record_response(Species) if @species.nil?
  end

  def new
    @species = Species.new
  end

  def edit
    standard_nil_record_response(Species) if @species.nil?
  end

  def create
    @species = Species.new(species_params)
    standard_create_response @species, @species.save, fields: @species_fields
  end

  def update
    standard_update_response @species, @species.update(species_params), fields: @species_fields
  end

  def destroy
    if @species.specimens.count > 0
      standard_destroy_response(@species, false, error: 'species.error.destroyed_has_specimens', source: params['source'])
    else
      standard_destroy_response(@species, @species.destroy, source: params['source'])
    end
  end

  private

  def set_species
    @species = Species.where(url: params[:url]).first
  end

  def set_species_fields
    @species_fields = [
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
      { name: :nutritive_group }
    ]
  end

  def species_params
    params.require(:species).permit(Species::PUBLIC_FIELDS)
  end
end
