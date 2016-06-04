RSpec.describe Language, type: :model do

  subject { FactoryGirl.create(:language) }

  it_behaves_like 'resource name', {
    class: Language,
    resource_name: 'language'
  }

  it_behaves_like 'resource paths', {
    class: Language,
    resource_name_index_path: 'admin_languages_path',
    resource_new_path: 'new_admin_language_path'
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
    it { is_expected.to belong_to(:parent) }
    it { is_expected.to have_many(:localized_pages) }
  end


  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:locale) }
    it { is_expected.to validate_presence_of(:flag) }
  end

end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  parent_id  :integer
#  name       :string(255)      not null
#  title      :string(255)      not null
#  locale     :string(255)      not null
#  flag       :string(255)      not null
#  default    :boolean
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_slug  (slug) UNIQUE
#
