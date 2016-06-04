class Specimen < ActiveRecord::Base
  extend FriendlyId
  include ResourceName
  include ResourcePaths
  include HabitatHelper
  include SubstrateHelper
  include FoI18n
  include LastUpdate
  include AuditCommentable

  # HABITATS_VALIDATION_ERROR = "have to be included in: #{elements_to_str(all_habitat_keys)}"
  SUBHABITATS_VALIDATION_ERROR = 'must take subhabitats from the list for specific habitat'
  SPECIES_VALIDATION_ERROR = 'must take species from the list for specific habitat and subhabitat'
  # SUBSTRATES_VALIDATION_ERROR = "have to be included in: #{all_substrate_keys.inspect}"

  PUBLIC_FIELDS = [:species_id, :location_id, :legator_id, :determinator_id, :determinator_text, :habitat, :substrate, :date, :quantity, :approved, :note]

  belongs_to :species
  belongs_to :location
  belongs_to :legator, class_name: 'User'
  belongs_to :determinator, class_name: 'User'

  has_many :characteristics, :through => :species

  friendly_id :slug_candidates, use: :slugged

  serialize :habitat, JSON
  serialize :substrate, JSON

  audited except: [:slug]

  validates :species, presence: true
  validates :location, presence: true
  validates :legator, presence: true
  validates :date, presence: true

  validate :habitat_json
  validate :substrate_json


  def resource_title
    "#{self.species.full_name} - #{self.location.name} - #{self.date}"
  end
  alias_method :audit_title, :resource_title


  private

  def slug_candidates
    candidates = []
    candidates << "#{self.species.full_name}_#{self.location.name}_#{date}" if !self.species.nil? && !self.location.nil?
    candidates << "#{self.species.full_name}_#{self.location.name}_#{date}_#{self.legator.full_name}" if !self.species.nil? && !self.location.nil? && !self.legator.nil?
    candidates << Time.now.to_s if candidates.empty?

    candidates
  end

  def habitat_json
    unless habitat.blank?
      if habitat.is_a?(String)
        unless all_habitat_keys(output: :string).include?(habitat)
          errors.add :habitat, "has to be included in: #{elements_to_str(all_habitat_keys)}"
          false
        end
      elsif habitat.keys.length > 1
        errors.add :habitat, 'incorrect habitats format'
        false
      elsif all_habitat_keys(output: :string).include?(habitat.keys.first)
        habitat_key = habitat.keys.first.to_s
        habitat_value = habitat.values.first
        habitat_value = {} unless habitat_value.is_a?(Hash)
        if habitat_value['subhabitat']
          allowed_subhabitats = subhabitat_keys(habitat_key)
          unless array_is_superset?(allowed_subhabitats, Array(habitat_value['subhabitat']))
            errors.add :habitat, SUBHABITATS_VALIDATION_ERROR
            false
          end
        end
        if habitat_value['species']
          allowed_species = elements_to_str(allowed_species(habitat_key, habitat_value['subhabitat']))
          species = elements_to_str(Array(habitat_value['species']))
          unless array_is_superset?(allowed_species, species)
            errors.add :habitat, SPECIES_VALIDATION_ERROR
            false
          end
        end
      else
        errors.add :habitat, "has to be included in: #{elements_to_str(all_habitat_keys)}"
        false
      end
    end
  end

  def substrate_json
    if !substrate.blank? && !all_substrate_keys(output: :string).include?(substrate)
      errors.add :substrate, "has to be included in: #{all_substrate_keys.inspect}"
      false
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
#  habitat           :text(65535)
#  substrate         :text(65535)
#  date              :date             not null
#  quantity          :text(65535)
#  note              :text(65535)
#  approved          :boolean
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
#
