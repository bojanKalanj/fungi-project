class Picture < ActiveRecord::Base

  TYPES = %w(in_situ fruiting_body microscopy flesh chemistry)

  belongs_to :species
  belongs_to :specimen
  belongs_to :reference
  belongs_to :user

  validate :source_presence_validation
  validate :target_presence_validation

  before_create :set_approved

  private

  def source_presence_validation
    if self.user.nil? && self.reference.nil?
      if self.source_title.blank? && self.source_url.blank?
        errors.add :user_id, 'needs to be specified'
      elsif self.source_title.blank?
        errors.add :source_title, 'needs to be specified'
      else
        errors.add :source_url, 'needs to be specified'
      end
    end
  end

  def target_presence_validation
    if self.specimen.nil? && self.species.nil?
      errors.add :specimen_id, 'needs to be specified'
    end
  end

  def set_approved

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
