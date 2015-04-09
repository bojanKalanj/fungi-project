FactoryGirl.define do
  factory :language do
    name "MyString"
slug_2 "MyString"
slug_3 "MyString"
  end

end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  slug_2     :string(255)      not null
#  slug_3     :string(255)      not null
#  default    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
