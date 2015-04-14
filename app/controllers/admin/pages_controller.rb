class Admin::PagesController < ApplicationController

  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.all
  end

  def show
  end

  def new
    @page = Page.new
    Language.all.each { |language| @page.localized_pages.build(language: language) }
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to admin_pages_path, notice: 'Strana uspešno kreirana.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @page.update_attributes(page_params)
        format.html { redirect_to admin_pages_path, notice: 'Strana uspešno ažurirana.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to admin_pages_url, notice: 'Strana uspešno obrisana.' }
      format.json { head :no_content }
    end
  end

  private

  def set_page
    @page = Page.friendly.find(params[:id])
  end

  def page_params
    params.require(:page).permit([:title, localized_pages_attributes: [:id, :title, :content, :language_id]])
  end
end
