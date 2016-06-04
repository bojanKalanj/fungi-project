module FoI18n
  extend ActiveSupport::Concern

  included do
  end

  def t(str, args={})
    I18n.translate!(str, args)
  rescue Exception => e
    if I18n.locale == :'sr-Latn'
      cyr_to_lat(I18n.translate!(str, args.merge(locale: :sr)))
    else
      raise e
    end
  end

  def l(str, args={})
    I18n.localize(str, args)
  rescue Exception => e
    if I18n.locale == :'sr-Latn'
      cyr_to_lat(I18n.localize(str, args.merge(locale: :sr)))
    else
      raise e
    end
  end

  private

  def cyr_to_lat(str)
    Fungiorbis::CyrToLat.transliterate str
  end
end