
RSpec.describe Stat, type: :model do
  subject { FactoryGirl.create(:stat) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'serialization' do
    it { is_expected.to serialize(:data) }
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
