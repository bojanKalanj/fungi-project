class LanguageSwitcherController < ApplicationController

  def update
    locale = params[:id].to_sym
    I18n.locale = I18n.available_locales.include?(locale) ? locale : I18n.default_locale
    redirect_to params[:path].blank? ? "/#{I18n.locale}" : params[:path]
  end

end