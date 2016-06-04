RSpec.describe Location, :type => :model do
  subject { FactoryGirl.create(:location) }

  it_behaves_like 'resource name', {
    class: Location,
    resource_name: 'location'
  }

  it_behaves_like 'resource paths', {
    class: Location,
    resource_name_index_path: 'admin_locations_path',
    resource_new_path: 'new_admin_location_path'
  }

  describe 'concerns' do
    it { expect(subject.class.ancestors.include? ResourceName).to be_truthy }
    it { expect(subject.class.ancestors.include? ResourcePaths).to be_truthy }
    it { expect(subject.class.ancestors.include? LastUpdate).to be_truthy }
    it { expect(subject.class.ancestors.include? AuditCommentable).to be_truthy }
  end

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
