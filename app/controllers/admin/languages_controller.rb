class Admin::LanguagesController < ApplicationController
  include StandardResponses

  before_action :set_language, only: [:show, :edit, :update, :destroy]
  before_action :set_language_fields, only: [:show, :new, :edit, :update]
  before_action :authenticate_user!

  def index
    @languages = Language.all

    @language_fields = [
      { name: :name },
      { name: :title },
      { name: :locale },
      { name: :flag, method: :parse_flag },
      { name: :default, method: :boolean_to_icon },
      { name: :parent, field: :name },
      { name: :actions, no_label: true }
    ]
  end

  def show
    standard_nil_record_response(Language) if @language.nil?
  end

  def new
    @language = Language.new
  end

  def edit
    standard_nil_record_response(Language) if @language.nil?
  end

  def create
    @language = Language.new(language_params)
    standard_create_response @language, @language.save
  end

  def update
    standard_update_response @language, @language.update(language_params)
  end

  def destroy
    if @language.localized_pages.count > 0
      standard_destroy_response(@language, false, error: 'language.error.destroyed_has_pages', source: params['source'])
    else
      standard_destroy_response(@language, @language.destroy, source: params['source'])
    end
  end

  private
  def set_language
    @language = Language.friendly.find(params[:id])
  end

  def set_language_fields
    @language_fields = [
      { name: :name },
      { name: :title },
      { name: :locale },
      { name: :flag, method: :parse_flag },
      { name: :default, method: :boolean_to_icon },
      { name: :parent, field: :name }
    ]
  end

  def language_params
    params.require(:language).permit(Language::PUBLIC_FIELDS)
  end
end
