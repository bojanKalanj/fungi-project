class Specimen < ActiveRecord::Base
  extend FriendlyId
  include Uuid
  include Resource
  include HabitatHelper
  include SubstrateHelper

  # HABITATS_VALIDATION_ERROR = "have to be included in: #{elements_to_str(all_habitat_keys)}"
  SUBHABITATS_VALIDATION_ERROR = 'must take subhabitats from the list for specific habitat'
  SPECIES_VALIDATION_ERROR = 'must take species from the list for specific habitat and subhabitat'
  # SUBSTRATES_VALIDATION_ERROR = "have to be included in: #{all_substrate_keys.inspect}"

  PUBLIC_FIELDS = [:species, :location, :legator, :determinator, :determinator_text, :habitats, :substrates, :date, :quantity, :approved]

  belongs_to :species
  belongs_to :location
  belongs_to :legator, class_name: 'User'
  belongs_to :determinator, class_name: 'User'

  has_many :characteristics, :through => :species

  friendly_id :slug_candidates, use: :slugged

  serialize :habitats, JSON
  serialize :substrates, JSON

  validate :habitats_array
  validate :substrates_array

  def resource_title
    "#{self.species.full_name} - #{self.location.name} - #{self.date}"
  end

  private

  def slug_candidates
    %W(#{self.species.full_name}_#{self.location.name}_#{date} #{self.species.full_name}_#{self.location.name}_#{date}_#{self.determinator.full_name})
  end

  def habitats_array
    if habitats.is_a? Array
      habitats.each do |habitat|
        if habitat.keys.length > 1
          errors.add :habitats, 'incorrect habitats format'
          return false
        elsif all_habitat_keys(output: :string).include?(habitat.keys.first.to_s)
          habitat_key = habitat.keys.first.to_s
          habitat = habitat.values.first
          unless habitat.empty? || !habitat[:subhabitat]
            allowed_subhabitats = subhabitat_keys(habitat_key)
            unless array_is_superset?(allowed_subhabitats, Array(habitat[:subhabitat]))
              errors.add :habitats, SUBHABITATS_VALIDATION_ERROR
              return false
            end
          end
          unless habitat.empty? || !habitat[:species]
            allowed_species = elements_to_str(allowed_species(habitat_key, habitat[:subhabitat]))
            species = elements_to_str(Array(habitat[:species]))
            unless array_is_superset?(allowed_species, species)
              errors.add :habitats, SPECIES_VALIDATION_ERROR
              return false
            end
          end
        else
          errors.add :habitats, "have to be included in: #{elements_to_str(all_habitat_keys)}"
          return false
        end
      end
    else
      true
    end
  end

  def substrates_array
    if substrates.is_a? Array
      s = elements_to_str substrates
      unless array_is_superset?(all_substrate_keys(output: :string), s)
        errors.add :substrates, "have to be included in: #{all_substrate_keys.inspect}"
        false
      end
    else
      true
    end
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
