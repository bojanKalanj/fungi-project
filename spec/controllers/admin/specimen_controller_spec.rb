RSpec.describe Admin::SpecimensController, type: :controller do

  let!(:localized_page) { FactoryGirl.create(:page, title: :home) }
  let!(:record) { FactoryGirl.create(:specimen) }

  let(:location){FactoryGirl.create(:location)}
  let(:user){FactoryGirl.create(:user)}
  let(:species){FactoryGirl.create(:species)}

  it_behaves_like 'admin controller', {
    class: Specimen,
    singular: :specimen,
    plural: :specimens,
    params: '{id: record.id}',
    valid_params: 'FactoryGirl.attributes_for(:specimen).merge({location_id: location.id, legator_id: user.id, species_id: species.id})'
  }
end
