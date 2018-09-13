FactoryGirl.define do
  factory :comment do
    commentable_type "MyString"
commentable_id 1
user_id 1
body "MyText"
  end

end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string(255)
#  commentable_id   :integer
#  user_id          :integer
#  body             :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
