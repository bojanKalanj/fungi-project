class LocalizedPagesController < ApplicationController

  def show
    if params[:page_id]
      I18n.locale = params[:id]
      language = Language.find_by_locale I18n.locale

      @localized_page = LocalizedPage.where(page_id: params[:page_id], language_id: language.id).first
    else
      @localized_page = LocalizedPage.find(params[:id])
    end
  end
end
