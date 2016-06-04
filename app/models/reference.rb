class Reference < ActiveRecord::Base
  extend FriendlyId
  include Resource
  include AuditCommentable

  PUBLIC_FIELDS = [:title, :authors, :isbn, :url]

  has_many :characteristics

  audited except: [:slug]

  validates :title, presence: true
  validates :isbn, uniqueness: true, allow_nil: true
  validates :url, format: { with: URI.regexp }, uniqueness: true, allow_nil: true

  friendly_id :full_title, use: :slugged

  def full_title
    self.authors.blank? ? self.title : "#{self.authors} -  #{self.title}"
  end

  alias_method :resource_title, :full_title
  alias_method :audit_title, :resource_title

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
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_references_on_slug  (slug)
#
