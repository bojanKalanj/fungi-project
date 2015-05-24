class Stat < ActiveRecord::Base

  serialize :data, JSON

  validates :data, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  def update_needed?
    case self.name
      when 'monthly_specimens_count'
        self.updated_at.year < Date.today.year || self.updated_at.month < Date.today.month
      when 'general_db_stats'
        updated_at < Species.last_update || updated_at < Specimen.last_update || updated_at < Location.last_update || updated_at < Characteristic.last_update
      when 'yearly_field_studies'
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
