RSpec.describe Reference, :type => :model do
  subject { FactoryGirl.create(:reference) }

  it_behaves_like 'resource name', {
    class: Reference,
    resource_name: 'reference'
  }

  it_behaves_like 'resource paths', {
    class: Reference,
    resource_name_index_path: 'admin_references_path',
    resource_new_path: 'new_admin_reference_path'
  }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'concerns' do
    it { expect(subject.class.ancestors.include? ResourceName).to be_truthy }
    it { expect(subject.class.ancestors.include? ResourcePaths).to be_truthy }
    it { expect(subject.class.ancestors.include? AuditCommentable).to be_truthy }
  end

  describe 'associations' do
    it { is_expected.to have_many(:characteristics) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:isbn).allow_nil }
    it { is_expected.to validate_uniqueness_of(:url).allow_nil }
    it { is_expected.to allow_value('http://www.some_site.com').for(:url) }
    it { is_expected.not_to allow_value('www.some_site.com').for(:url) }
  end
end

# == Schema Information
#
# Table name: references
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  authors    :string(255)
#  isbn       :string(255)
#  url        :string(255)
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_references_on_slug  (slug)
#
