RSpec.describe Admin::UsersController, :type => :controller do

  let!(:record){FactoryGirl.create(:user)}

  describe 'GET #index' do
    context 'when signed in as supervisor' do
      login_supervisor

      let!(:localized_page){ FactoryGirl.create(:page, title: :home)}

      it 'lists users' do
        response = get :index
        expect(response).to be_success
        expect(assigns(:users)).to eq User.all
        expect(response).to render_template(:index)
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :index, {}
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :index, {}
    end
  end

  describe 'GET #show' do

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :show, '{id: record.id}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :show, '{id: record.id}'
    end
  end

  describe 'GET #new' do
  end

  describe 'GET #edit' do

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :edit, '{id: record.id}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :edit, '{id: record.id}'
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
    end

    context 'with invalid params' do
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :post, :create, '{id: record.id, record.resource_name_sym => {id: record.id}}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :post, :create, '{id: record.id}'
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
    end

    context 'with invalid params' do
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :patch, :update, '{id: record.id, record.resource_name_sym => {id: record.id}}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :patch, :update, '{id: record.id}'
    end
  end

  describe 'DELETE #destroy' do

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :delete, :destroy, '{id: record.id, record.resource_name_sym => {id: record.id}}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :delete, :destroy, '{id: record.id}'
    end

  end

end
