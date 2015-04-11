require 'rails_helper'

RSpec.describe Characteristic, :type => :model do
  subject { FactoryGirl.create(:characteristic) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:species) }
    it { is_expected.to belong_to(:reference) }
  end

  describe 'serialization' do
    it { is_expected.to serialize(:fruiting_body) }
    it { is_expected.to serialize(:microscopy) }
    it { is_expected.to serialize(:flesh) }
    it { is_expected.to serialize(:chemistry) }
    it { is_expected.to serialize(:note) }
    it { is_expected.to serialize(:habitats) }
    it { is_expected.to serialize(:substrates) }
  end

end

# == Schema Information
#
# Table name: characteristics
#
#  id            :integer          not null, primary key
#  reference_id  :integer          not null
#  species_id    :integer          not null
#  edible        :boolean
#  cultivated    :boolean
#  poisonous     :boolean
#  medicinal     :boolean
#  fruiting_body :text(65535)
#  microscopy    :text(65535)
#  flesh         :text(65535)
#  chemistry     :text(65535)
#  note          :text(65535)
#  habitats      :text(65535)
#  substrates    :text(65535)
#  uuid          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_characteristics_on_reference_id  (reference_id)
#  index_characteristics_on_species_id    (species_id)
#  index_characteristics_on_uuid          (uuid)
#
