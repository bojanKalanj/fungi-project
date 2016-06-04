RSpec.describe Admin::PagesController, type: :controller do

  let!(:localized_page){ FactoryGirl.create(:page, title: :home)}
  let!(:record){FactoryGirl.create(:page)}

  it_behaves_like 'admin controller', {
    class: Page,
    singular: :page,
    plural: :pages,
    params: '{id: record.id}',
    valid_params: 'FactoryGirl.attributes_for(:randomized_page)'
  }
end
