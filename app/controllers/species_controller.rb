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
    unless params[:h].blank?
      if params[:sh].blank?
        c = Characteristic.where('habitats like ?', '%' + params['h'].gsub(/,|:|-/, '%')+'%').pluck(:species_id)
      else
        c = Characteristic.where('habitats like ?', '%' + params['sh'].gsub(/,|:|-/, '%')+'%').pluck(:species_id)
      end
      @species = @species.where(id: c)

      subhabitat_keys = subhabitat_keys(params[:h])
      @subhabitats = subhabitat_keys.map { |key| [t("habitats.#{params[:h]}.subhabitat.#{key}.title"), key] } unless subhabitat_keys.blank?
    end

    @params = params
  end
end
