class SpeciesController < ApplicationController
  include HabitatHelper

  def index
    @species = Species.all
  end

  def show
    @species = Species.find(params[:url])
  end

  def search
    @species = Species.includes(:characteristics).includes(:specimens).paginate(:page => params[:page])

    unless params[:s].blank?
      @species = @species.where('genus = ? or familia = ? or ordo = ? or subclassis = ? or classis = ? or subphylum = ? or phylum = ?',
                                params[:s], params[:s], params[:s], params[:s], params[:s], params[:s], params[:s])
    end

    @subhabitats = nil
    @habitat_species = nil
    c = Characteristic
    unless params[:h].blank?
      if params[:sh].blank?
        c = c.where('habitats like ?', '%' + params['h'] + '%')
      else
        c = c.where('habitats like ?', '%' + params['sh'] + '%')
      end

      unless params[:sp].blank?
        params[:sp].each do |sp|
          c = c.where('habitats like ?', '%' + sp + '%')
        end
      end

      subhabitat_keys = subhabitat_keys(params[:h])
      @subhabitats = subhabitat_keys.map { |key| [t("habitats.#{params[:h]}.subhabitat.#{key}.title"), key] } unless subhabitat_keys.blank?

      habitat_species_keys = allowed_species(params[:h], params[:sh])
      @habitat_species = habitat_species_keys.map { |key| [localized_habitat_species_name(key), key] } unless habitat_species_keys.blank?
    end

    c = c.where('substrates like ?', '%' + params['sb'] + '%') unless params[:sb].blank?

    @species = @species.where(nutritive_group: params['ng']) unless params[:ng].blank?
    @species = @species.where(growth_type: params['gt']) unless params[:gt].blank?

    @species = @species.where(id: c.pluck(:species_id)) unless c == Characteristic

    @params = params
  end
end
