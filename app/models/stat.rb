class Stat < ActiveRecord::Base

  STAT_MONTHLY_SPECIMENS_COUNT = 'monthly_specimens_count'.freeze
  STAT_GENERAL_DB_STATS = 'general_db_stats'.freeze
  STAT_YEARLY_FIELD_STUDIES = 'yearly_field_studies'.freeze

  STAT_NAMES = [STAT_MONTHLY_SPECIMENS_COUNT, STAT_GENERAL_DB_STATS, STAT_YEARLY_FIELD_STUDIES].freeze

  serialize :data, JSON

  validates :data, presence: true
  validates :name, uniqueness: true, inclusion: { in: STAT_NAMES }, presence: true

  def update_needed?
    case self.name
      when STAT_MONTHLY_SPECIMENS_COUNT
        self.updated_at.year < Date.today.year || self.updated_at.month < Date.today.month
      when STAT_GENERAL_DB_STATS
        updated_at < Species.last_update || updated_at < Specimen.last_update || updated_at < Location.last_update || updated_at < Characteristic.last_update
      when STAT_YEARLY_FIELD_STUDIES
        updated_at < Specimen.last_update
      else
        rails 'unknown stats name'
    end
  end

end

# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  data       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
