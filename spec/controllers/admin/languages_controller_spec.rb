RSpec.describe Admin::LanguagesController, type: :controller do
  let!(:record) { FactoryGirl.create(:language_cyrillic) }
  let!(:localized_page) { FactoryGirl.create(:page, title: :home) }

  it_behaves_like 'admin controller', {
    class: Language,
    singular: :language,
    plural: :languages,
    params: '{id: record.id}',
    valid_params: 'FactoryGirl.attributes_for(:language_english)'
  }
end
