require 'rails_helper'

RSpec.describe LocalizedPage, type: :model do
  subject { FactoryGirl.create(:localized_page) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:language) }
    it { is_expected.to belong_to(:page) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
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
#
# Indexes
#
#  index_localized_pages_on_language_id  (language_id)
#  index_localized_pages_on_page_id      (page_id)
#
