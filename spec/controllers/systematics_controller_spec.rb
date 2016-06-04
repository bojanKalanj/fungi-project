RSpec.describe SystematicsController, type: :controller do
  render_views

  let!(:species){FactoryGirl.create(:species)}

  describe 'GET #show' do
    %w(phylum subphylum classis subclassis ordo familia genus).each do |id|
      context "when requesting #{id}" do
        it 'returns http success' do
          response = get :show, id: id, format: :json
          expect(response).to be_success
        end
      end
    end
  end

end
