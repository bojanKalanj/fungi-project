FactoryGirl.define do

  factory :picture do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'images', 'fungiorbis.png')) }
    type { Picture::TYPES.sample }
    source_url { Faker::Internet.url }
    source_title { Faker::Lorem.sentence(3) }
    user { create(:user) }
    species { create(:species) }
  end

  factory :bare_picture, class: Picture do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'images', 'fungiorbis.png')) }
    type { Picture::TYPES.sample }
  end

end

# == Schema Information
#
# Table name: pictures
#
#  id           :integer          not null, primary key
#  reference_id :integer
#  user_id      :integer
#  species_id   :integer
#  specimen_id  :integer
#  image        :string(255)      not null
#  type         :string(255)      not null
#  approved     :boolean          default(FALSE)
#  source_url   :string(255)
#  source_title :string(255)
#
# Indexes
#
#  fk_rails_3268570edc  (user_id)
#  fk_rails_6feec66a2f  (species_id)
#  fk_rails_89135305c9  (reference_id)
#
