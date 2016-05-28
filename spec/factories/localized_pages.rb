FactoryGirl.define do
  factory :localized_page do
    title 'home'
    language {FactoryGirl.create(:language)}
    page {FactoryGirl.create(:page)}
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
