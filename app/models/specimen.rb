class Specimen < ActiveRecord::Base
  extend FriendlyId
  include Resource
  include HabitatHelper
  include SubstrateHelper
  include FoI18n

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

  validates :species, presence: true
  validates :location, presence: true
  validates :legator, presence: true
  validates :date, presence: true

  def resource_title
    "#{self.species.full_name} - #{self.location.name} - #{self.date}"
  end


  private

  def slug_candidates
    candidates = []
    candidates << "#{self.species.full_name}_#{self.location.name}_#{date}" if !self.species.nil? && !self.location.nil?
    candidates << "#{self.species.full_name}_#{self.location.name}_#{date}_#{self.legator.full_name}" if !self.species.nil? && !self.location.nil? && !self.legator.nil?
    candidates << Time.now.to_s if candidates.empty?

    candidates
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
