require 'fungiorbis/statistics'
class LocalizedPagesController < ApplicationController

  before_action :detect_locale_from_url

  def show
    page_attributes = {}

    if root_page_requested?
      page_attributes[:locale] = @locale_from_url || I18n.default_locale
      @general_db_stats = Fungiorbis::Statistics.new(:general_db_stats).get
    else
      page_attributes[:slug] = params[:id]
    end

    @localized_page = LocalizedPage.where(page_attributes).first
    I18n.locale = @localized_page.language.locale.to_sym
  end

  private

  def detect_locale_from_url
    @locale_from_url = I18n.available_locales.select { |l| l.to_s.downcase.underscore == params['id'].to_s.downcase.underscore }.first
  end

  def root_page_requested?
    params[:id].blank? || @locale_from_url
  end
end
