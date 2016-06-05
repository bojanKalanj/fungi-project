RSpec.describe Admin::HabitatsController, type: :controller do
  render_views

  describe 'index' do
    context 'whith habitat only' do
      it 'lists habitats' do
        expect(subject).to receive(:subhabitat_keys).with('forest').and_return(%w(a b c))
        expect(subject).to receive(:allowed_species).with('forest', nil).and_return(%w(x y z))
        allow(subject).to receive(:localized_habitat_species_name).and_return(nil)

        response = xhr :get, :index, habitat: 'forest', format: :js

        expect(response).to be_success
        expect(assigns(:habitat)).to eq 'forest'
        expect(assigns(:subhabitats)).to match_array [[nil, "a"], [nil, "b"], [nil, "c"]]
        expect(assigns(:species)).to match_array [[nil, "x"], [nil, "y"], [nil, "z"]]
      end
    end

    context 'with habitat and subhabitat' do
      it 'lists habitats' do
        expect(subject).to receive(:allowed_species).with('forest', 'coniferous').and_return(%w(x y z))
        allow(subject).to receive(:localized_habitat_species_name).and_return(nil)

        response = xhr :get, :index, habitat: 'forest', subhabitat: 'coniferous', format: :js

        expect(response).to be_success
        expect(assigns(:habitat)).to eq 'forest'
        expect(assigns(:species)).to match_array [[nil, "x"], [nil, "y"], [nil, "z"]]
      end
    end
  end
end
