require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
