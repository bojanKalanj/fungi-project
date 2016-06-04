RSpec.describe Admin::SpeciesController, type: :controller do

  let!(:localized_page){ FactoryGirl.create(:page, title: :home)}
  let!(:record){FactoryGirl.create(:species)}

  it_behaves_like 'admin controller', {
    class: Species,
    singular: :species,
    plural: :species,
    params: '{url: record.url}',
    valid_params: 'FactoryGirl.attributes_for(:species)'
  }
end
