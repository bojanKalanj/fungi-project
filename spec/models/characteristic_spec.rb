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

  describe 'validations' do
    it { is_expected.to validate_presence_of(:species_id) }
    it { is_expected.to validate_presence_of(:reference_id) }
    it { is_expected.to validate_uniqueness_of(:reference_id).scoped_to(:species_id) }

    context 'custom validators' do

      describe 'habitats_array' do
        context 'when habitats is not an array' do
          it 'is valid when habitats is blank' do
            expect { FactoryGirl.create(:characteristic, habitats: nil) }.not_to raise_error
            expect { FactoryGirl.create(:characteristic, habitats: '') }.not_to raise_error
            # TODO check this edge case
            # expect { FactoryGirl.create(:characteristic, habitats: []) }.not_to raise_error
          end

          it 'is valid when habitats is a string that belongs to allowed keys' do
            # TODO check if this is supported
            expect { FactoryGirl.create(:characteristic, habitats: all_habitat_keys(output: :string).sample) }.not_to raise_error
          end

          it 'is invalid when habitats is a string that does not belong to allowed keys' do
            expect { FactoryGirl.create(:characteristic, habitats: 'wrong_habitat') }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end

        context 'when habitats is an array of hashes' do
          it 'is invalid when habitat hash has more then one keys' do
            expect { FactoryGirl.create(:characteristic, habitats: [{ 'meadow' => {}, 'forest' => {} }]) }.to raise_error(ActiveRecord::RecordInvalid)
          end

          context 'when all habitat keys belong to allowed keys' do
            it 'is invalid when some habitat keys are not allowed' do
              expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => {} }, { 'forestx' => {} }]) }.to raise_error(ActiveRecord::RecordInvalid)
            end

            it 'is valid without subhabitats or species' do
              expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => {} }]) }.not_to raise_error
            end

            context 'with subhabitats' do
              it 'is valid with allowed subhabitats' do
                expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => { 'subhabitat' => 'deciduous' } }]) }.not_to raise_error
              end

              it 'is invalid with not allowed hsubhabitats' do
                expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => { 'subhabitat' => 'deciduousxx' } }]) }.to raise_error(ActiveRecord::RecordInvalid)
              end
            end

            context 'with species' do
              it 'is valid when all species are allowed' do
                expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => { 'subhabitat' => 'deciduous', 'species' => ['quercus'] } }]) }.not_to raise_error
                expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => { 'species' => ['quercus'] } }]) }.not_to raise_error
              end

              it 'is invalid when not all species are allowed' do
                expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => { 'subhabitat' => 'deciduous', 'species' => ['quercus', 'quercusx'] } }]) }.to raise_error(ActiveRecord::RecordInvalid)
                expect { FactoryGirl.create(:characteristic, habitats: [{ 'forest' => { 'species' => ['quercus', 'quercusx'] } }]) }.to raise_error(ActiveRecord::RecordInvalid)
              end
            end
          end

        end
      end

      describe 'substrates_array' do
        context 'when substrates_array is not an array' do
          it 'is valid when substrates_array is blank' do
            expect { FactoryGirl.create(:characteristic, substrates: nil) }.not_to raise_error
            expect { FactoryGirl.create(:characteristic, substrates: '') }.not_to raise_error
            # TODO check this edge case
            # expect { FactoryGirl.create(:characteristic, substrates: []) }.not_to raise_error
          end

          it 'is valid when substrates is a string that belongs to allowed keys' do
            # TODO check if this is supported
            expect { FactoryGirl.create(:characteristic, substrates: all_substrate_keys(output: :string).sample) }.not_to raise_error
          end

          it 'is invalid when substrates is a string that does not belong to allowed keys' do
            expect { FactoryGirl.create(:characteristic, substrates: 'wrong_substrate') }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end

        context 'when substrates is an array' do
          it 'is invalid when some substrates are not allowed' do
            expect { FactoryGirl.create(:characteristic, substrates: ['stump', 'stumpx']) }.to raise_error(ActiveRecord::RecordInvalid)
          end

          it 'is valid when all substrates are allowed' do
            expect { FactoryGirl.create(:characteristic, substrates: [all_substrate_keys(output: :string).sample]) }.not_to raise_error
          end
        end
      end

      describe 'localized_hashes' do
        it 'is valid when hash is blank' do
          [:fruiting_body, :microscopy, :flesh, :chemistry].each do |field|
            expect { FactoryGirl.create(:characteristic, field => nil) }.not_to raise_error
            expect { FactoryGirl.create(:characteristic, field => '') }.not_to raise_error
          end
        end

        it 'is valid when fields are localized in all locales' do
          [:fruiting_body, :microscopy, :flesh, :chemistry].each do |field|
            expect { FactoryGirl.create(:characteristic, field => Hash[*I18n.available_locales.map.collect { |locale| [locale, 'some text'] }.flatten]) }.not_to raise_error
          end
        end

        it 'is invalid when some fields contain localization in unsupported locales' do
          [:fruiting_body, :microscopy, :flesh, :chemistry].each do |field|
            expect { FactoryGirl.create(:characteristic, field => Hash[*(I18n.available_locales + [:de]).map.collect { |locale| [locale, 'some text'] }.flatten]) }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end
      end
    end
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
#  slug          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_characteristics_on_reference_id  (reference_id)
#  index_characteristics_on_slug          (slug)
#  index_characteristics_on_species_id    (species_id)
#
