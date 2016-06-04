RSpec.describe Admin::SpeciesController, type: :controller do

  let!(:record){FactoryGirl.create(:species)}

  describe 'GET #index' do

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :index, {}
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :index, {}
    end
  end

  describe 'GET #show' do

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :show, '{url: record.url}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :show, '{url: record.url}'
    end
  end

  describe 'GET #new' do
  end

  describe 'GET #edit' do

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :edit, '{url: record.url}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :edit, '{url: record.url}'
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
    end

    context 'with invalid params' do
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :post, :create, '{url: record.url, record.resource_name_sym => {url: record.url}}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :post, :create, '{url: record.url}'
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
    end

    context 'with invalid params' do
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :patch, :update, '{url: record.url, record.resource_name_sym => {url: record.url}}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :patch, :update, '{url: record.url}'
    end
  end

  describe 'DELETE #destroy' do

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :delete, :destroy, '{url: record.url, record.resource_name_sym => {url: record.url}}'
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :delete, :destroy, '{url: record.url}'
    end

  end
end
