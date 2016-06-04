RSpec.describe Admin::LocationsController, type: :controller do

  let!(:record){FactoryGirl.create(:location)}
  let!(:localized_page){ FactoryGirl.create(:page, title: :home)}

  it_behaves_like 'admin controller', {
    class: Location,
    singular: :location,
    plural: :locations,
    params: '{id: record.id}',
    valid_params: 'FactoryGirl.attributes_for(:location)'
  }
end
