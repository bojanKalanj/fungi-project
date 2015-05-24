require 'fungiorbis/statistics'
class LocalizedPagesController < ApplicationController

  def show
    locale = params[:id] == 'sr-latn' ? :'sr-Latn' : params[:id].to_s.to_sym

    if params[:page_id] && (params[:id].blank? || I18n.available_locales.include?(locale))
      if !params[:id].blank? && I18n.available_locales.include?(locale)
        language = Language.find_by_locale locale || Language.find_by_locale(I18n.locale)
        I18n.locale = language.locale
      else
        language = Language.find_by_locale I18n.locale
      end

      @localized_page = LocalizedPage.where(page_id: params[:page_id], language_id: language.id).first
    else
      @localized_page = LocalizedPage.where(title: params[:id]).first
      I18n.locale = @localized_page.language.locale
    end

    if @localized_page.first?
      @general_db_stats = Fungiorbis::Statistics.new(:general_db_stats).get
    end
  end

end
