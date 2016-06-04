RSpec.describe Admin::ReferencesController, type: :controller do

  let!(:localized_page){ FactoryGirl.create(:page, title: :home)}
  let!(:record){FactoryGirl.create(:reference)}

  it_behaves_like 'admin controller', {
    class: Reference,
    singular: :reference,
    plural: :references,
    params: '{id: record.id}',
    valid_params: 'FactoryGirl.attributes_for(:reference)'
  }
end
