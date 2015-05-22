class SpeciesController < ApplicationController

  def index
    @species = Species.all
  end

  def show
    @species = Species.find(params[:url])
  end

  def search
    @species = Species.includes(:characteristics).includes(:specimens).paginate(:page => params[:page])
  end
end
