class SpecimensController < ApplicationController
  before_action :set_specimen, only: [:show, :edit, :update, :destroy]

  # GET /specimen
  # GET /specimen.json
  def index
    @specimens = Specimen.includes(:species).all.paginate(:page => params[:page])
  end

  # GET /specimen/1
  # GET /specimen/1.json
  def show
  end

  # GET /specimen/new
  def new
    @specimen = Specimen.new
  end

  # GET /specimen/1/edit
  def edit
  end

  # POST /specimen
  # POST /specimen.json
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

  # PATCH/PUT /specimen/1
  # PATCH/PUT /specimen/1.json
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

  # DELETE /specimen/1
  # DELETE /specimen/1.json
  def destroy
    @specimen.destroy
    respond_to do |format|
      format.html { redirect_to specimen_index_url, notice: 'Specimen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specimen
      @specimen = Specimen.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def specimen_params
      params[:specimen]
    end
end
