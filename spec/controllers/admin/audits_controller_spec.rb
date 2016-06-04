describe Admin::AuditsController, type: :controller do
  render_views


  context 'when signed in as super admin' do
    login_supervisor

    let!(:page){ FactoryGirl.create(:page)}
    let(:audit) { FactoryGirl.create(:audit, auditable_id: page.id, auditable_type: 'Page')}

    describe 'GET index' do
      it 'indexes all audits' do
        response = get :index
        expect(response).to be_success
        expect(assigns(:audits)).to eq Audit.all.order('created_at desc').limit(300)
        expect(response).to render_template(:index)
      end
    end

    describe 'GET show' do
      it 'shows an audit' do
        response = get :show, id: audit.id
        expect(response).to be_success
        expect(assigns(:audit)).to eq audit
        expect(response).to render_template(:show)
      end
    end
  end
end