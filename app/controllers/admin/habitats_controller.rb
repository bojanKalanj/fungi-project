class Admin::HabitatsController < ApplicationController
  include HabitatHelper

  before_action :authenticate_user!

  respond_to :js

  def index
    if !params[:subhabitat].blank? && !params[:habitat].blank?
      @habitat = params[:habitat]
      @species = allowed_species(@habitat, params[:subhabitat]).map { |key| [localized_habitat_species_name(key), key] }
      @index = params[:index]
      render :index
    elsif !params[:habitat].blank?
      @habitat = params[:habitat]
      @subhabitats = subhabitat_keys(@habitat).to_a.map { |key| [t("habitats.#{@habitat}.subhabitat.#{key}.title"), key] }
      @species = allowed_species(@habitat, nil).map { |key| [localized_habitat_species_name(key), key] }
    end
    @for_specimen = params[:for_specimen]
  end
end
