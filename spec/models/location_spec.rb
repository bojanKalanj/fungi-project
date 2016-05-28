
RSpec.describe Location, :type => :model do
  subject { FactoryGirl.create(:location) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:specimens) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:utm) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end

# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  utm        :string(255)      not null
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_name  (name)
#  index_locations_on_slug  (slug)
#
