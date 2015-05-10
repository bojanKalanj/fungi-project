class Admin::PagesController < ApplicationController
  include StandardResponses

  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_page_fields
  before_action :authenticate_user!

  def index
    @pages = Page.all

    @page_fields = [
      { name: :title },
      { name: :actions, no_label: true }
    ]
  end

  def show
    standard_nil_record_response(Page) if @page.nil?
  end

  def new
    @page = Page.new
    Language.all.each { |language| @page.localized_pages.build(language: language) }
  end

  def edit
    standard_nil_record_response(Page) if @page.nil?
  end

  def create
    @page = Page.new(page_params)
    standard_create_response @page, @page.save
  end

  def update
    standard_update_response @page, @page.update_attributes(page_params)
  end

  def destroy
    standard_destroy_response(@page, @page.destroy, source: params['source'])
  end

  private

  def set_page
    @page = Page.friendly.find(params[:id])
  end

  def set_page_fields
    @page_fields = [
      { name: :title }
    ]

    @localized_page_fields = [
      { name: :title },
      { name: :content, input_html: { class: 'wysiwyg' } }
    ]
  end

  def page_params
    params.require(:page).permit([:title, localized_pages_attributes: [:id, :title, :content, :language_id, :page_id]])
  end
end
