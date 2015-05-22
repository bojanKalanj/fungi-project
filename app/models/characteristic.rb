class Characteristic < ActiveRecord::Base
  extend FriendlyId
  include Resource
  include HabitatHelper
  include SubstrateHelper

  # HABITATS_VALIDATION_ERROR = "have to be included in: #{elements_to_str(all_habitat_keys)}"
  SUBHABITATS_VALIDATION_ERROR = 'must take subhabitats from the list for specific habitat'
  SPECIES_VALIDATION_ERROR = 'must take species from the list for specific habitat and subhabitat'
  # SUBSTRATES_VALIDATION_ERROR = "have to be included in: #{all_substrate_keys.inspect}"

  FLAGS = [:edible, :cultivated, :poisonous, :medicinal]

  PUBLIC_FIELDS = [:reference_id, :species_id, :edible, :cultivated, :poisonous, :medicinal,
                   { fruiting_body: I18n.available_locales },
                   { microscopy: I18n.available_locales },
                   { flesh: I18n.available_locales },
                   { chemistry: I18n.available_locales },
                   { note: I18n.available_locales }]

  belongs_to :species
  belongs_to :reference

  friendly_id :slug_candidates, use: :slugged

  serialize :fruiting_body, JSON
  serialize :microscopy, JSON
  serialize :flesh, JSON
  serialize :chemistry, JSON
  serialize :note, JSON

  serialize :habitats, JSON
  serialize :substrates, JSON

  validates :species_id, presence: true
  validates :reference_id, presence: true
  validates :reference_id, uniqueness: { scope: :species }

  validate :habitats_array
  validate :substrates_array
  validate :localized_hashes

  def resource_title
    I18n.translate('characteristic.interface.index')
  end

  def short
    [:edible, :cultivated, :poisonous, :medicinal].map { |field| field if self.send(field) }.compact
  end

  def long
    [:fruiting_body, :microscopy, :flesh, :chemistry].map do |field|
      locale = I18n.locale == :'sr-Latn' ? 'sr' : I18n.locale.to_s

      { field => self.send(field)[locale] } if self.send(field) && !self.send(field)[locale].blank?
    end.compact
  end

  private

  def localized_hashes
    locales = elements_to_str I18n.available_locales
    [:fruiting_body, :microscopy, :flesh, :chemistry].each do |field|
      hash = self.send(field)
      unless hash.blank? || array_is_superset?(locales, hash.keys)
        errors.add field, "locale keys have to be included in #{locales}"
      end
    end
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
          habitat = {} unless habitat.is_a?(Hash)
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

  def slug_candidates
    [self.reference.title+'-'+self.species.full_name, self.reference.title, self.reference.full_title]
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
