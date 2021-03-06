FactoryGirl.define do
  factory :reference do
    title { Faker::Lorem.sentence }
    authors { Faker::Name.name }
    url { ["http://#{rand(Time.now.to_i)}", nil].sample }
    isbn { [Faker::Code.isbn, nil].sample }
  end

  factory :reference_with_characteristics, parent: :reference do |reference|
    after(:create) do |r|
      (1 + rand(3)).times{ create(:characteristic, reference: r)}
    end
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
