RSpec.describe Reference, type: :model do
  subject { FactoryGirl.create(:picture) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:species) }
    it { is_expected.to belong_to(:specimen) }
    it { is_expected.to belong_to(:reference) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    describe 'source_presence_validation' do
      context 'source is missing' do
        context 'no source info at all' do
          specify {}
        end
      end
    end

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
