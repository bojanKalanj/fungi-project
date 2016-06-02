RSpec.describe Stat, type: :model do
  subject { FactoryGirl.create(:stat) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'serialization' do
    it { is_expected.to serialize(:data) }
  end

  describe 'update_needed?' do
    context "when stat type is '#{Stat::STAT_MONTHLY_SPECIMENS_COUNT}'" do
      context 'with recent stats' do
        let!(:stat) { FactoryGirl.create(:stat, name: Stat::STAT_MONTHLY_SPECIMENS_COUNT) }
        specify { expect(stat.update_needed?).to be_falsey }
      end

      context 'with stale stats' do
        let!(:stat) { FactoryGirl.create(:stat, name: Stat::STAT_MONTHLY_SPECIMENS_COUNT, created_at: (Date.today-32), updated_at: (Date.today-32)) }
        specify { expect(stat.update_needed?).to be_truthy }
      end
    end

    context "when stat type is '#{Stat::STAT_GENERAL_DB_STATS}'" do
      context 'when stats are not stale' do
        before(:each) do
          [:species, :specimen, :location, :characteristic].each { |factory| FactoryGirl.create(factory, created_at: Date.yesterday, updated_at: Date.yesterday) }
        end
        let!(:stat){FactoryGirl.create(:stat, name: Stat::STAT_GENERAL_DB_STATS)}
        specify { expect(stat.update_needed?).to be_falsey }
      end

      [:species, :specimen, :location, :characteristic].each do |factory|
        context "when #{factory} stat is stale" do
          ([:species, :specimen, :location, :characteristic]-[factory]).each { |f| let!(f) { FactoryGirl.create(f, created_at: Date.today-2, updated_at: Date.today-2) } }
          let!(:stat) { FactoryGirl.create(:stat, name: Stat::STAT_GENERAL_DB_STATS, created_at: Date.yesterday, updated_at: Date.yesterday) }
          let!(factory) { FactoryGirl.create(factory) }
          specify { expect(stat.update_needed?).to be_truthy }
        end
      end
    end

    context "when stat type is '#{Stat::STAT_YEARLY_FIELD_STUDIES}'" do
      context 'when stat is not stale' do
        let!(:specimen) { FactoryGirl.create(:specimen, created_at: Date.yesterday, updated_at: Date.yesterday) }
        let!(:stat) { FactoryGirl.create(:stat, name: Stat::STAT_YEARLY_FIELD_STUDIES) }
        specify { expect(stat.update_needed?).to be_falsey }
      end

      context 'when stat is stale' do
        let!(:specimen) { FactoryGirl.create(:specimen) }
        let!(:stat) { FactoryGirl.create(:stat, name: Stat::STAT_YEARLY_FIELD_STUDIES, created_at: Date.yesterday, updated_at: Date.yesterday) }
        specify { expect(stat.update_needed?).to be_truthy }
      end
    end
  end
end

# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  data       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
