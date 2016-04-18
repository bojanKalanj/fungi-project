require 'rails_helper'

RSpec.describe Specimen, :type => :model do
  subject { FactoryGirl.create(:specimen) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:species) }
    it { is_expected.to belong_to(:location) }
    it { is_expected.to belong_to(:legator) }
    it { is_expected.to belong_to(:determinator) }
    it { is_expected.to have_many(:characteristics).through(:species) }
  end

  describe 'serialization' do
    it { is_expected.to serialize(:habitat) }
    it { is_expected.to serialize(:substrate) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:species) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:legator) }
    it { is_expected.to validate_presence_of(:date) }

    context 'custom validators' do

      describe 'habitat_json' do
        it 'is valid when habitat is blank' do
          expect { FactoryGirl.create(:specimen, habitat: nil) }.not_to raise_error
          expect { FactoryGirl.create(:specimen, habitat: '') }.not_to raise_error
          # TODO check this edge case
          expect { FactoryGirl.create(:specimen, habitat: {}) }.not_to raise_error
        end

        it 'is valid when habitat is a string that belongs to allowed keys' do
          # TODO check if this is supported
          expect { FactoryGirl.create(:specimen, habitat: all_habitat_keys(output: :string).sample) }.not_to raise_error
        end

        it 'is invalid when habitat is a string that does not belong to allowed keys' do
          # TODO check this edge case
          expect { FactoryGirl.create(:specimen, habitat: 'wrong_habitat') }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'is invalid when habitat hash has more then one keys' do
          expect { FactoryGirl.create(:specimen, habitat: { 'meadow' => {}, 'forest' => {} }) }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'is invalid when habitat key is not allowed' do
          expect { FactoryGirl.create(:specimen, habitat: { 'forestx' => {} }) }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'is valid without subhabitats or species' do
          expect { FactoryGirl.create(:specimen, habitat: { 'forest' => {} }) }.not_to raise_error
        end

        context 'with subhabitats' do
          it 'is valid with allowed subhabitats' do
            expect { FactoryGirl.create(:specimen, habitat: { 'forest' => { 'subhabitat' => 'deciduous' } }) }.not_to raise_error
          end

          it 'is invalid with not allowed subhabitats' do
            expect { FactoryGirl.create(:specimen, habitat: { 'forest' => { 'subhabitat' => 'deciduousxx' } }) }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end

        context 'with species' do
          it 'is valid when all species are allowed' do
            expect { FactoryGirl.create(:specimen, habitat: { 'forest' => { 'subhabitat' => 'deciduous', 'species' => ['quercus'] } }) }.not_to raise_error
            expect { FactoryGirl.create(:specimen, habitat: { 'forest' => { 'species' => ['quercus'] } }) }.not_to raise_error
          end

          it 'is invalid when not all species are allowed' do
            expect { FactoryGirl.create(:specimen, habitat: { 'forest' => { 'subhabitat' => 'deciduous', 'species' => ['quercus', 'quercusx'] } }) }.to raise_error(ActiveRecord::RecordInvalid)
            expect { FactoryGirl.create(:specimen, habitat: { 'forest' => { 'species' => ['quercus', 'quercusx'] } }) }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end
      end

      describe 'substrate_json' do
        it 'is valid when substrate is blank' do
          expect { FactoryGirl.create(:specimen, substrate: nil) }.not_to raise_error
          expect { FactoryGirl.create(:specimen, substrate: '') }.not_to raise_error
        end

        it 'is valid when substrate belongs to allowed substrates' do
          expect { FactoryGirl.create(:specimen, substrate: all_substrate_keys(output: :string).sample) }.not_to raise_error
        end

        it 'is invalid when substrate is a string that does not belong to allowed substrates' do
          expect { FactoryGirl.create(:specimen, substrate: 'wrong_substrate') }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: specimen
#
#  id                :integer          not null, primary key
#  species_id        :integer          not null
#  location_id       :integer          not null
#  legator_id        :integer          not null
#  legator_text      :string(255)
#  determinator_id   :integer
#  determinator_text :string(255)
#  habitat           :text(65535)
#  substrate         :text(65535)
#  date              :date             not null
#  quantity          :text(65535)
#  note              :text(65535)
#  approved          :boolean
#  slug              :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_specimen_on_determinator_id  (determinator_id)
#  index_specimen_on_legator_id       (legator_id)
#  index_specimen_on_location_id      (location_id)
#  index_specimen_on_slug             (slug)
#  index_specimen_on_species_id       (species_id)
#
