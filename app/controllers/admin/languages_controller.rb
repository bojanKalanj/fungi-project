class Admin::LanguagesController < Admin::AdminController

  before_action :set_language
  before_action :set_language_fields

  authorize_resource

  def destroy
    if @language.localized_pages.count > 0
      standard_destroy_response(@language, false, error: 'language.error.destroyed_has_pages', source: params['source'])
    else
      standard_destroy_response(@language, @language.destroy, source: params['source'])
    end
  end

  private
  def set_language
    if action == :new
      @language = Language.new
    elsif action == :create
      @language = Language.new(resource_params)
    elsif action == :index
      @languages = Language.all
    else
      @language = Language.friendly.find(params[:id])
    end
  end

  def set_language_fields
    if action == :index
      @fields = [
        { name: :name },
        { name: :title },
        { name: :locale },
        { name: :flag, method: :parse_flag },
        { name: :default, method: :boolean_to_icon },
        { name: :parent, field: :name },
        { name: :actions, no_label: true }
      ]
    else
      @fields = [
        { name: :name },
        { name: :title },
        { name: :locale },
        { name: :flag, method: :parse_flag },
        { name: :default, method: :boolean_to_icon },
        { name: :parent, field: :name }
      ]
    end
  end

  def resource_params
    params.require(:language).permit(Language::PUBLIC_FIELDS)
  end

  def current_resource
    @language
  end
end
