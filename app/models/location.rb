class Location < ActiveRecord::Base
  extend FriendlyId
  include Uuid

  PER_PAGE = 10
  MAX_PER_PAGE = 100

  has_many :specimens, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :utm, presence: true

  friendly_id :slug_candidates, use: :slugged

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
#  uuid       :string(255)
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_name  (name)
#  index_locations_on_slug  (slug)
#
