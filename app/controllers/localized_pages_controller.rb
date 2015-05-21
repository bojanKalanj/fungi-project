class LocalizedPagesController < ApplicationController

  def show
    language = Language.find_by_locale I18n.locale

    if params[:page_id] && (params[:id].blank? || I18n.available_locales.include?(params[:id].to_sym))
      @localized_page = LocalizedPage.where(page_id: params[:page_id], language_id: language.id).first
    else
      page_id = LocalizedPage.where(title: params[:id]).pluck(:page_id).first
      @localized_page = LocalizedPage.where(page_id: page_id, language_id: language.id).first
    end
  end
end
