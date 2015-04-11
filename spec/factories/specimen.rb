require_relative "#{Rails.root}/app/models/concerns/habitat_helper"
require_relative "#{Rails.root}/app/models/concerns/substrate_helper"
include HabitatHelper
include SubstrateHelper

FactoryGirl.define do
  factory :specimen, :class => 'Specimen' do
    association :species, factory: :species
    association :location, factory: :location
    association :legator, factory: :user
    association :determinator, factory: :user
    legator_text "MyString"
    determinator_text "MyString"
    habitats { random_habitats }
    substrates { random_substrates }
    date "2014-11-28"
    quantity "MyText"
  end
end

# == Schema Information
#
# Table name: specimen
#
#  id                :integer          not null, primary key
#  species_id        :integer          not null
#  location_id       :integer          not null
#  legator_id        :integer          not null
#  legator_text      :string(255)
#  determinator_id   :integer
#  determinator_text :string(255)
#  habitats          :text(65535)
#  substrates        :text(65535)
#  date              :date             not null
#  quantity          :text(65535)
#  note              :text(65535)
#  approved          :boolean
#  uuid              :string(255)
#  slug              :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_specimen_on_determinator_id  (determinator_id)
#  index_specimen_on_legator_id       (legator_id)
#  index_specimen_on_location_id      (location_id)
#  index_specimen_on_slug             (slug)
#  index_specimen_on_species_id       (species_id)
#  index_specimen_on_uuid             (uuid)
#
