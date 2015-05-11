FactoryGirl.define do
  factory :location do
    name Faker::Lorem.sentence
    utm %w(34TDR200 34TDR210 34TDQ209 34TDR210).sample
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
