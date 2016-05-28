module Fungiorbis
  module FactoryHelper

    AVAILABLE_LANGUAGES = %w(cyrillic latin english).freeze

    def create_languages!(languages: AVAILABLE_LANGUAGES)
      l = {}
      languages.each do |language_title|
        parent_id = language_title == 'latin' && l[:cyrillic] ? l[:cyrillic].id : nil
        l[language_title.to_sym] = FactoryGirl.create(:"language_#{language_title}", parent_id: parent_id)
      end
    end

    def localize_page!(page, languages: AVAILABLE_LANGUAGES)
      languages.each do |language_title|
        language = Language.where(locale: language_title_to_locale(language_title)).first
        if language && page
          FactoryGirl.create(:localized_page, page: page, language: language, title: "#{language_title} #{page.title}", content: "#{language_title} content #{page.title}")
        end
      end
    end

    private

    def language_title_to_locale(language_title)
      case language_title
        when 'cyrillic'
          'sr'
        when 'latin'
          'sr-Latn'
        when 'english'
          'en'
        else
          raise "unknown language title: #{language_title}"
      end
    end
  end
end