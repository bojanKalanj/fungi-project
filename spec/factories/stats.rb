FactoryGirl.define do
  factory :stat do
    name %w(monthly_specimens_count general_db_stats yearly_field_studies).sample
    data "some data"
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
