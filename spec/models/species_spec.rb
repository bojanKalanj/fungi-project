RSpec.describe Species, :type => :model do
  subject { FactoryGirl.create(:species) }

  it_behaves_like 'resource name', {
    class: Species,
    resource_name: 'species'
  }

  it_behaves_like 'resource paths', {
    class: Species,
    resource_name_index_path: 'admin_species_index_path',
    resource_new_path: 'new_admin_species_path'
  }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'concerns' do
    it { expect(subject.class.ancestors.include? ResourceName).to be_truthy }
    it { expect(subject.class.ancestors.include? ResourcePaths).to be_truthy }
    it { expect(subject.class.ancestors.include? LastUpdate).to be_truthy }
    it { expect(subject.class.ancestors.include? AuditCommentable).to be_truthy }
  end

  describe 'associations' do
    it { is_expected.to have_many(:characteristics) }
    it { is_expected.to have_many(:specimens) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:genus) }
    it { is_expected.to validate_presence_of(:familia) }
    it { is_expected.to validate_presence_of(:ordo) }
    it { is_expected.to validate_presence_of(:subclassis) }
    it { is_expected.to validate_presence_of(:classis) }
    it { is_expected.to validate_presence_of(:subphylum) }
    it { is_expected.to validate_presence_of(:phylum) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:genus).with_message(Species::NAME_GENUS_VALIDATION_ERROR) }

    it { is_expected.to validate_inclusion_of(:nutritive_group).in_array(Species::NUTRITIVE_GROUPS) }
    it { is_expected.to validate_inclusion_of(:growth_type).in_array(Species::GROWTH_TYPES) }
  end

  describe 'callbacks' do
    context 'before_validation' do

      describe 'generate_url' do
        context 'when new record' do
          it 'generates url' do
            species = Species.new FactoryGirl.attributes_for(:species)
            expect(species).to receive(:generate_url).and_call_original
            species.save
          end
        end

        context 'when existing record' do
          it 'generates url' do
            expect(subject).to receive(:generate_url).and_call_original
            subject.save
          end
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: species
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  genus           :string(255)      not null
#  familia         :string(255)      not null
#  ordo            :string(255)      not null
#  subclassis      :string(255)      not null
#  classis         :string(255)      not null
#  subphylum       :string(255)      not null
#  phylum          :string(255)      not null
#  synonyms        :text(65535)
#  growth_type     :string(255)
#  nutritive_group :string(255)
#  url             :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_species_on_url  (url)
#
