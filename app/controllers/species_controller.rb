class SpeciesController < ApplicationController

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
  end
end
