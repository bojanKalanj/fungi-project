class Admin::PagesController < Admin::AdminController

  before_action :set_page
  before_action :set_page_fields

  authorize_resource

  private

  def set_page
    if action == :new
      @page = Page.new
      Language.all.each { |language| @page.localized_pages.build(language: language) }
    elsif action == :create
      @page = Page.new(resource_params)
    elsif action == :index
      @pages = Page.all
    else
      @page = Page.friendly.find(params[:id])
    end
  end

  def set_page_fields
    if action == :index
      @fields = [
        { name: :title },
        { name: :actions, no_label: true }
      ]
    else
      @fields = [
        { name: :title }
      ]
    end

    @localized_page_fields = [
      { name: :title },
      { name: :content, input_html: { class: 'wysiwyg' } }
    ]
  end

  def resource_params
    params.require(:page).permit([:title, localized_pages_attributes: [:id, :title, :content, :language_id, :page_id]])
  end

  def current_resource
    @page
  end
end
