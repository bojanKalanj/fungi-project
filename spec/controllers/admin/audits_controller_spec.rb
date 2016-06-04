describe Admin::AuditsController, type: :controller do
  render_views

  let!(:page) { FactoryGirl.create(:page) }
  let(:audit) { FactoryGirl.create(:audit, auditable_id: page.id, auditable_type: 'Page') }

  describe 'GET index' do
    context 'when signed in as supervisor' do
      login_supervisor

      it 'indexes all audits' do
        response = get :index
        expect(response).to be_success
        expect(assigns(:audits)).to eq Audit.order('created_at desc').limit(300)
        expect(response).to render_template(:index)
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :index, {}, nil
    end

    context 'with non authenticated user' do
      it_behaves_like 'forbidden for non supervisors', :get, :index, {}, nil
    end
  end

  describe 'GET show' do
    context 'when signed in as supervisor' do
      login_supervisor

      it 'shows an audit' do
        response = get :show, id: audit.id
        expect(response).to be_success
        expect(assigns(:audit)).to eq audit
        expect(response).to render_template(:show)
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :show, '{id: audit.id }'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :show, '{id: audit.id}'
    end
  end
end
