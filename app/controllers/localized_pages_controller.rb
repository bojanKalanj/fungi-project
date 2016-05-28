require 'fungiorbis/statistics'
class LocalizedPagesController < ApplicationController

  def show
    locale = I18n.available_locales.select { |l| l.to_s.downcase.underscore == params['id'].to_s.downcase.underscore }.first
    if params[:id].blank? || locale
      @localized_page = LocalizedPage.where(locale: locale || I18n.default_locale).first
      @general_db_stats = Fungiorbis::Statistics.new(:general_db_stats).get
    else
      @localized_page = LocalizedPage.where(title: params[:id]).first
    end
    I18n.locale = @localized_page.language.locale.to_sym
  end

end
