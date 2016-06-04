RSpec.describe Page, type: :model do

  subject { FactoryGirl.create(:page) }

  it_behaves_like 'resource name', {
    class: Page,
    resource_name: 'page'
  }

  it_behaves_like 'resource paths', {
    class: Page,
    resource_name_index_path: 'admin_pages_path',
    resource_new_path: 'new_admin_page_path'
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
    it { is_expected.to have_many(:localized_pages) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for :localized_pages }
  end
end

# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
