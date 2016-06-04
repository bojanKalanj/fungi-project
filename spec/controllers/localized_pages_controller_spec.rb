RSpec.describe LocalizedPagesController, type: :controller do
  include Fungiorbis::FactoryHelper

  render_views

  let(:page){ FactoryGirl.create(:page)}
  let(:page2){ FactoryGirl.create(:page)}

  before(:each) do
    create_languages!
    localize_page!(page)
    localize_page!(page2)
  end

  after(:each) do
    I18n.locale = I18n.default_locale
  end

  describe 'GET #show' do
    context 'when root page requested' do
      context 'with blank id' do
        I18n.available_locales.each do |locale|
          it "#{locale} - sets default locale and renders root page" do
            I18n.locale = locale

            response = get :show

            expect(response).to be_success
            expect(assigns(:localized_page)).to eq page.localized_pages.for_locale(I18n.default_locale).first
            expect(assigns(:general_db_stats)).to be_truthy
            expect(I18n.locale).to eq I18n.default_locale
          end
        end
      end

      context 'with locale in id' do
        it 'sets given locale and renders root page' do
          old_locale = I18n.locale
          locale = (I18n.available_locales - [old_locale]).sample

          response = get :show, id: locale

          expect(response).to be_success
          expect(assigns(:localized_page)).to eq page.localized_pages.for_locale(locale).first
          expect(assigns(:general_db_stats)).to be_truthy
          expect(I18n.locale).to eq locale
        end
      end
    end

    context 'when page other then root page requested' do
      context 'when locale does not change' do
        it 'renders page' do
          old_locale = I18n.locale
          localized_page = page2.localized_pages.for_locale(old_locale).first

          response = get :show, id: localized_page.slug

          expect(response).to be_success
          expect(assigns(:localized_page)).to eq localized_page
          expect(assigns(:general_db_stats)).to be_falsey
          expect(I18n.locale).to eq old_locale
        end
      end

      context 'when locale changes' do
        it 'sets given locale and renders page' do
          old_locale = I18n.locale
          locale = (I18n.available_locales - [old_locale]).sample

          localized_page = page2.localized_pages.for_locale(locale).first

          response = get :show, id: localized_page.slug

          expect(response).to be_success
          expect(assigns(:localized_page)).to eq localized_page
          expect(assigns(:general_db_stats)).to be_falsey
          expect(I18n.locale).to eq locale
        end
      end
    end
  end
end
