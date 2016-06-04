RSpec.describe SpecimensController, type: :controller do
  render_views

  let(:species) { FactoryGirl.create(:species_with_characteristics) }
  let!(:localized_page){ FactoryGirl.create(:page, title: :home)}

  describe 'GET #show' do
    let(:specimen) { FactoryGirl.create(:specimen, species: species) }
    it 'assigns and renders specimens' do
      response = get :show, id: specimen.slug
      expect(response).to be_success
      expect(assigns(:specimen)).to eq specimen
    end
  end

  # describe 'GET #search' do
  #   let(:species_1) { FactoryGirl.create(:species) }
  #   let(:species_2) { FactoryGirl.create(:species) }
  #   let(:species_3) { FactoryGirl.create(:species) }
  #
  #   before(:each) do
  #     FactoryGirl.create(:blank_characteristic, species: species_1, habitats: 'forest')
  #     FactoryGirl.create(:blank_characteristic, species: species_2, habitats: [{ 'forest' => { 'subhabitat' => 'deciduous', 'species' => ['sambucus'] } }])
  #     FactoryGirl.create(:blank_characteristic, species: species_3, habitats: [{ 'sands' => { 'species' => ['sambucus'] } }])
  #     FactoryGirl.create(:blank_characteristic, species: species_1, edible: true)
  #     FactoryGirl.create(:blank_characteristic, species: species_1, medicinal: true)
  #     FactoryGirl.create(:blank_characteristic, species: species_2, edible: true, medicinal: true)
  #   end
  #
  #   context 'with blank params' do
  #     it 'returns all species' do
  #       response = get :search
  #
  #       expect(response).to be_success
  #       expect(assigns(:species)).to match_array Species.all
  #       expect(assigns(:subhabitats)).to be_nil
  #       expect(assigns(:habitat_species)).to be_nil
  #       expect(assigns(:params)).to eq({ 'controller' => 'species', 'action' => 'search' })
  #     end
  #   end
  #
  #   context 'with single habitat param' do
  #     it 'returns correct matches' do
  #       response = get :search, sp: ['sambucus']
  #
  #       expect(response).to be_success
  #       expect(assigns(:species)).to match_array [species_2, species_3]
  #       expect(assigns(:subhabitats)).to be_nil
  #       expect(assigns(:habitat_species)).to be_nil
  #       expect(assigns(:params)).to eq({ 'controller' => 'species', 'action' => 'search', 'sp' => ['sambucus'] })
  #     end
  #   end
  #
  #   context 'with several habitat params' do
  #     it 'returns correct matches' do
  #       response = get :search, h: 'sands', sp: ['sambucus']
  #
  #       expect(response).to be_success
  #       expect(assigns(:species)).to match_array [species_3]
  #       expect(assigns(:subhabitats)).to be_nil
  #       expect(assigns(:habitat_species)).not_to be_nil
  #       expect(assigns(:params)).to eq({ 'controller' => 'species', 'action' => 'search', 'sp' => ['sambucus'], 'h' => 'sands' })
  #     end
  #   end
  #
  #   context 'with single boolean characteristic' do
  #     [:edible, :medicinal].each do |flag|
  #       it "returns correct matches #{flag}" do
  #         response = get :search, flag => true
  #
  #         expect(response).to be_success
  #         expect(assigns(:species)).to match_array [species_1, species_2]
  #         expect(assigns(:subhabitats)).to be_nil
  #         expect(assigns(:habitat_species)).to be_nil
  #         expect(assigns(:params)).to eq({ 'controller' => 'species', 'action' => 'search', flag.to_s => true })
  #       end
  #     end
  #   end
  #
  #   context 'with several boolean characteristics' do
  #     it 'returns correct matches' do
  #       response = get :search, edible: true, medicinal: true
  #
  #       expect(response).to be_success
  #       expect(assigns(:species)).to match_array [species_1, species_2]
  #       expect(assigns(:subhabitats)).to be_nil
  #       expect(assigns(:habitat_species)).to be_nil
  #       expect(assigns(:params)).to eq({ 'controller' => 'species', 'action' => 'search', 'edible' => true, 'medicinal' => true })
  #     end
  #   end
  #
  #   context 'with complex params' do
  #     it 'returns correct matches' do
  #       response = get :search, h: 'forest', edible: true
  #
  #       expect(response).to be_success
  #       expect(assigns(:species)).to match_array [species_1, species_2]
  #       expect(assigns(:subhabitats)).not_to be_nil
  #       expect(assigns(:habitat_species)).not_to be_nil
  #     end
  #   end
  # end
end
