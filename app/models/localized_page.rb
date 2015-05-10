require 'fungiorbis/cyr_to_lat'

class LocalizedPage < ActiveRecord::Base
  extend FriendlyId
  include Resource

  belongs_to :language
  belongs_to :page

  friendly_id :title, use: :slugged

  validates :title, presence: true, uniqueness: true, unless: :dependant?

  def localized_field(field)
    if dependant?
      Fungiorbis::CyrToLat.transliterate self.page.localized_pages.find_by_language_id(self.language.parent.id).send(field)
    else
      self.send(field)
    end
  end

  def resource_title
    localized_field(:title)
  end

  private

  def dependant?
    self.language.parent_id?
  end
end

# == Schema Information
#
# Table name: localized_pages
#
#  id          :integer          not null, primary key
#  language_id :integer
#  page_id     :integer
#  title       :string(255)
#  content     :text(65535)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_localized_pages_on_language_id  (language_id)
#  index_localized_pages_on_page_id      (page_id)
#
