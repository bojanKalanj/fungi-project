class Admin::SpecimensController < ApplicationController
  include StandardResponses

  before_action :set_specimen, only: [:show, :edit, :update, :destroy]
  before_action :set_specimen_fields
  before_action :authenticate_user!

  def index
    @specimens = Specimen.includes(:species, :location).all

    @specimen_fields = [
      { name: :species, field: :full_name, class: 'italic' },
      { name: :location, field: :name },
      { name: :date },
      { name: :habitat_title },
      { name: :substrate_title },
      { name: :actions, no_label: true }
    ]
  end

  def show
    standard_nil_record_response(Specimen) if @specimen.nil?
  end

  def new
    @specimen = Specimen.new
  end

  def edit
  end

  def create
    @specimen = Specimen.new(specimen_params)

    respond_to do |format|
      if @specimen.save
        format.html { redirect_to @specimen, notice: 'Specimen was successfully created.' }
        format.json { render :show, status: :created, location: @specimen }
      else
        format.html { render :new }
        format.json { render json: @specimen.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @specimen.update(specimen_params)
        format.html { redirect_to @specimen, notice: 'Specimen was successfully updated.' }
        format.json { render :show, status: :ok, location: @specimen }
      else
        format.html { render :edit }
        format.json { render json: @specimen.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @specimen.destroy
    respond_to do |format|
      format.html { redirect_to specimen_index_url, notice: 'Specimen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_specimen
      @specimen = Specimen.friendly.find(params[:id])
    end

  def set_specimen_fields
    @species_fields = [
      { name: :species, input_html: { class: 'italic' } },
      { name: :location }
    ]
  end

    def specimen_params
      params[:specimen]
    end
end
