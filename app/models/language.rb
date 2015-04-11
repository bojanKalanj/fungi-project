class Language < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  def locale_slug
    self.locale.downcase.gsub('-', '_')
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
