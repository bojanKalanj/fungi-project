RSpec.describe StatisticsController, type: :controller do

  let!(:specimen){FactoryGirl.create(:specimen)}

  describe 'GET #show' do
    %w(yearly_field_studies monthly_specimens_count).each do |id|
      context "when requesting #{id}" do
        it 'returns http success' do
          response = get :show, id: id, format: :json
          expect(response).to be_success
        end
      end
    end
  end

end
