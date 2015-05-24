class Species < ActiveRecord::Base
  extend FriendlyId
  include Resource
  include LastUpdate

  GROWTH_TYPES = %w(single group)
  NUTRITIVE_GROUPS = %w(parasitic mycorrhizal saprotrophic parasitic-saprotrophic saprotrophic-parasitic)
  NAME_GENUS_VALIDATION_ERROR = '- genus combination must be unique'
  GROWTH_TYPE_VALIDATION_ERROR = "has to be one of: #{GROWTH_TYPES.inspect}"
  NUTRITIVE_GROUPS_VALIDATION_ERROR = "has to be one of: #{NUTRITIVE_GROUPS.inspect}"

  PUBLIC_FIELDS = [:name, :genus, :familia, :ordo, :subclassis, :classis, :subphylum, :phylum, :synonyms, :growth_type, :nutritive_group]

  has_many :characteristics, dependent: :destroy
  has_many :specimens

  before_validation :generate_url

  friendly_id :url

  self.per_page = 20

  validates :name, presence: true, uniqueness: { scope: :genus, case_sensitive: false, message: NAME_GENUS_VALIDATION_ERROR }
  validates :genus, presence: true
  validates :familia, presence: true
  validates :ordo, presence: true
  validates :subclassis, presence: true
  validates :classis, presence: true
  validates :subphylum, presence: true
  validates :phylum, presence: true
  # validates :url, presence: true, uniqueness: true

  validates :growth_type, allow_blank: true, inclusion: { in: GROWTH_TYPES, message: GROWTH_TYPE_VALIDATION_ERROR }
  validates :nutritive_group, allow_blank: true, inclusion: { in: NUTRITIVE_GROUPS, message: NUTRITIVE_GROUPS_VALIDATION_ERROR }

  def full_name
    "#{self.genus} #{self.name}"
  end

  alias_method :resource_title, :full_name

  def self.usability_count(usability)
    Characteristic.where(usability => true).select(:species_id).distinct.count
  end

  def systematics
    [:name, :genus, :familia, :ordo, :subclassis, :classis, :subphylum, :phylum].map{ |s| self.send(s)}
  end

  def combined_characteristics(locale=I18n.locale)
    hash = {
      fruiting_body: [],
      microscopy: [],
      flesh: [],
      chemistry: [],
      note: [],
      habitats: [],
      substrates: [],
      edible: [],
      cultivated: [],
      poisonous: [],
      medicinal: []
    }

    characteristics_keys = hash.keys

    self.characteristics.each do |c|
      characteristics_keys.each do |key|
        unless c.send(key).blank?
          if Characteristic::FLAGS.include?(key) && c.send(key)  || [:habitats, :substrates].include?(key)
            hash[key] << { value: c.send(key), reference_id: c.reference_id }
          elsif c.send(key).is_a?(Hash) && !c.send(key)[locale].blank?
            hash[key] << { value: c.send(key)[locale], reference_id: c.reference_id }
          end
        end
      end
    end

    hash
  end

  protected

  def generate_url
    self.url = "#{self.genus}-#{self.name}".strip.gsub(' ', '_').gsub('.', '').downcase
  end

end

# == Schema Information
#
# Table name: species
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  genus           :string(255)      not null
#  familia         :string(255)      not null
#  ordo            :string(255)      not null
#  subclassis      :string(255)      not null
#  classis         :string(255)      not null
#  subphylum       :string(255)      not null
#  phylum          :string(255)      not null
#  synonyms        :text(65535)
#  growth_type     :string(255)
#  nutritive_group :string(255)
#  url             :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_species_on_url  (url)
#
