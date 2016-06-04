class Location < ActiveRecord::Base
  extend FriendlyId
  include ResourceName
  include ResourcePaths
  include LastUpdate
  include AuditCommentable

  PUBLIC_FIELDS = [:name, :utm]

  has_many :specimens

  audited except: [:slug]

  validates :name, presence: true, uniqueness: true
  validates :utm, presence: true

  friendly_id :slug_candidates, use: :slugged

  def resource_title
    self.name
  end
  alias_method :audit_title, :resource_title

  private

  def slug_candidates
    [:name, [:name, :utm]]
  end
end

# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  utm        :string(255)      not null
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_name  (name)
#  index_locations_on_slug  (slug)
#
