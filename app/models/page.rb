class Page < ActiveRecord::Base
  extend FriendlyId

  has_many :localized_pages, dependent: :destroy

  friendly_id :title, use: :slugged
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
