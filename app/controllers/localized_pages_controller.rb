class LocalizedPagesController < ApplicationController

  def show
    if params[:id]
      @localized_page = LocalizedPage.find(params[:id])
    else
      language = Language.find_by_locale I18n.locale
      @localized_page = LocalizedPage.where(page_id: params[:page_id], language_id: language.id).first
    end
  end
end
