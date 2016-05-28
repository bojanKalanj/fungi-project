FactoryGirl.define do
  factory :language do
    name 'English'
    title 'english'
    locale 'en'
    flag 'gb'
  end

  factory :language_cyrillic, parent: :language do
    name 'Serbian Cyrillic'
    title 'ћирилица'
    locale 'sr'
    flag 'rs'
    default false
    # slug 'serbian-cyrillic'
  end

  factory :language_latin, parent: :language do
    name 'Serbian'
    title 'latinica'
    locale 'sr-Latn'
    flag 'rs'
    default true
    # slug 'serbian'
  end

  factory :language_english, parent: :language do
    name 'English'
    title 'english'
    locale 'en'
    flag 'gb'
    default false
    # slug 'english'
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
