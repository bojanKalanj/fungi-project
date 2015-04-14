class Page < ActiveRecord::Base
  extend FriendlyId

  has_many :localized_pages, dependent: :destroy

  friendly_id :title, use: :slugged

  accepts_nested_attributes_for :localized_pages

  validates :title, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
