class Reference < ActiveRecord::Base
  extend FriendlyId
  include Uuid
  include Resource

  PUBLIC_FIELDS = [:title, :authors, :isbn, :url]

  has_many :characteristics

  validates :title, presence: true
  validates :isbn, uniqueness: true, if: 'isbn.present?'
  validates :url, format: { with: URI.regexp }, uniqueness: true, if: 'url.present?'

  friendly_id :full_title, use: :slugged

  def full_title
    "#{self.authors} -  #{self.title}"
  end
  alias_method :resource_title, :full_title

end

# == Schema Information
#
# Table name: references
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  authors    :string(255)
#  isbn       :string(255)
#  url        :string(255)
#  uuid       :string(255)
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_references_on_slug  (slug)
#  index_references_on_uuid  (uuid)
#
