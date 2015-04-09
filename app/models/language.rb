class Language < ActiveRecord::Base
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
