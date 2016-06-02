class SpecimensController < ApplicationController
  include HabitatHelper

  before_action :clean_params, only: :search

  def show
    @specimen = Specimen.friendly.find(params[:id])
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
end
