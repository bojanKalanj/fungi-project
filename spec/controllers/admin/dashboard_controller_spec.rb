RSpec.describe Admin::DashboardController, type: :controller do
  render_views

  describe 'show' do
    context 'when signed in as supervisor' do
      login_supervisor

      let!(:localized_page){ FactoryGirl.create(:page, title: :home)}

      it 'shows dashboard' do
        response = get :show
        expect(response).to be_success
        expect(assigns(:audits)).to eq Audit.order('created_at DESC').limit(10)
        expect(response).to render_template(:show)
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :show, {}
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :show, {}
    end
  end
end