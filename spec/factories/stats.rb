FactoryGirl.define do
  factory :stat do
    name Stat::STAT_NAMES.sample
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
