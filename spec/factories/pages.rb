FactoryGirl.define do
  factory :page do
    title Faker::Shakespeare.hamlet_quote
    before(:create) do |page|
      while Page.where(title: page.title).count > 0 do
        page.title = Faker::Shakespeare.hamlet_quote
      end
    end
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
