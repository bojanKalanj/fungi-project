RSpec.describe LanguageSwitcherController, type: :controller do
  include Fungiorbis::FactoryHelper

  describe 'PATCH update' do

    let(:page) { FactoryGirl.create(:page) }
    let(:page2) { FactoryGirl.create(:page) }

    before(:each) do
      create_languages!
      localize_page!(page)
      localize_page!(page2)
    end

    context 'when path is given' do
      it 'sets locale and redirects to path' do
        old_locale = I18n.locale
        locale = (I18n.available_locales - [old_locale]).sample
        path = localized_page_path(page2.localized_pages.for_locale(locale))

        response = patch :update, id: locale.to_s, path: path

        expect(I18n.locale).not_to eq old_locale
        expect(response).to redirect_to(path)
      end
    end

    context 'when path is not given' do
      it 'sets locale and redirects to "locale path"' do
        old_locale = I18n.locale
        locale = (I18n.available_locales - [old_locale]).sample

        response = patch :update, id: locale.to_s, path: ''

        expect(I18n.locale).not_to eq old_locale
        expect(response).to redirect_to("/#{locale}")
      end
    end
  end

end
