RSpec.describe LocalizedPage, type: :model do
  subject { FactoryGirl.create(:localized_page) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'concerns' do
    it { expect(subject.class.ancestors.include? AuditCommentable).to be_truthy }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:language) }
    it { is_expected.to belong_to(:page) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'callbacks' do
    context 'before_validation' do
      describe 'set_locale' do
        specify do
          subject.locale = nil
          expect(subject).to receive(:set_locale).once.and_call_original
          subject.valid?
          expect(subject.locale).to eq subject.language.locale
        end
      end
    end
  end

  describe 'scopes' do
    describe 'without_home' do
      let(:page1){ FactoryGirl.create(:page)}
      let!(:lp1){ FactoryGirl.create(:localized_page, page: page1)}
      let(:page2){ FactoryGirl.create(:page)}
      let!(:lp2){ FactoryGirl.create(:localized_page, page: page2, title: 'abc')}

      specify { expect(LocalizedPage.without_home).to eq [lp2]}
    end
  end
end

# == Schema Information
#
# Table name: localized_pages
#
#  id          :integer          not null, primary key
#  language_id :integer
#  page_id     :integer
#  title       :string(255)      not null
#  content     :text(65535)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  locale      :string(255)      default("sr")
#
# Indexes
#
#  index_localized_pages_on_language_id  (language_id)
#  index_localized_pages_on_page_id      (page_id)
#
