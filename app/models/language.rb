class Language < ActiveRecord::Base
  extend FriendlyId
  include Resource

  PUBLIC_FIELDS = [:name, :title, :locale, :flag, :default, :parent]

  belongs_to :parent, class_name: 'Language'
  has_many :localized_pages

  friendly_id :name, use: :slugged

  class << self
    def parent_locale_for_current
      l = Language.where(locale: I18n.locale).first
      if l.parent.nil?
        I18n.locale
      else
        l.parent.locale.to_sym
      end
    end
  end

  def locale_slug
    self.locale.downcase.gsub('-', '_')
  end

  def resource_title
    self.name
  end
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  parent_id  :integer
#  name       :string(255)      not null
#  title      :string(255)      not null
#  locale     :string(255)      not null
#  flag       :string(255)      not null
#  default    :boolean
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_slug  (slug) UNIQUE
#
