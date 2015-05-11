require_relative "#{Rails.root}/app/models/concerns/habitat_helper"
require_relative "#{Rails.root}/app/models/concerns/substrate_helper"
include HabitatHelper
include SubstrateHelper

FactoryGirl.define do
  factory :characteristic do
    association :species, factory: :species
    association :reference, factory: :reference
    # reference
    edible { [false, true, nil].sample }
    cultivated { [false, true, nil].sample }
    poisonous { [false, true, nil].sample }
    medicinal { [false, true, nil].sample }
    fruiting_body { {} }
    microscopy { {} }
    flesh { {} }
    chemistry { {} }
    note { {} }
    habitats { random_habitats }
    substrates { random_substrates }
  end
end

# == Schema Information
#
# Table name: characteristics
#
#  id            :integer          not null, primary key
#  reference_id  :integer          not null
#  species_id    :integer          not null
#  edible        :boolean
#  cultivated    :boolean
#  poisonous     :boolean
#  medicinal     :boolean
#  fruiting_body :text(65535)
#  microscopy    :text(65535)
#  flesh         :text(65535)
#  chemistry     :text(65535)
#  note          :text(65535)
#  habitats      :text(65535)
#  substrates    :text(65535)
#  slug          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_characteristics_on_reference_id  (reference_id)
#  index_characteristics_on_slug          (slug)
#  index_characteristics_on_species_id    (species_id)
#
