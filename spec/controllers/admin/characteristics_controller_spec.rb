RSpec.describe Admin::CharacteristicsController, type: :controller do
  render_views

  let!(:species) { FactoryGirl.create(:species) }

  describe 'index' do
    context 'when signed in as supervisor' do
      login_supervisor

      it 'lists characteristics' do
        response = xhr :get, :index, species_url: species.url, format: :js
        expect(response).to be_success
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :index, '{species_url: species.url}', :js
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :index, '{species_url: species.url}', :js
    end
  end


  describe 'POST #create' do
    context 'when signed in as supervisor' do
      login_supervisor

      context 'with valid params' do
        it 'creates new characteristic' do
          old_characteristics_count = species.characteristics.count
          expect(old_characteristics_count).to eq 0

          valid_params = {
            reference_id: FactoryGirl.create(:reference).id,
            edible: '0',
            cultivated: '1',
            poisonous: '0',
            medicinal: '0',
            habitats: {
              '1465143214' => {
                'forest' => {
                  'subhabitat' => 'coniferous',
                  'species' => ['picea'],
                  'habitat' => 'forest' } },
              '1465143231' => {
                'meadow' => {
                  'habitat' =>
                    'meadow' } } },
            substrates: ['', 'litter', 'living_tree'],
            fruiting_body: { 'sr' => 'fr body sr', 'en' => '' },
            microscopy: { 'sr' => '', 'en' => 'microscopy en' },
            flesh: { 'sr' => '', 'en' => '' },
            chemistry: { 'sr' => '', 'en' => '' },
            note: { 'sr' => '', 'en' => '' }
          }

          response = post :create, species_url: species.url, format: :js, characteristic: valid_params

          expect(response).to be_success
          expect(assigns(:characteristics)).to eq species.characteristics
          expect(species.characteristics.count).to eq 1
          expect(response).to render_template(:index)

          c = species.characteristics.first
          expect(c.cultivated).to be_truthy
          [:edible, :poisonous, :medicinal].each { |u| expect(c.send(u)).to be_falsey }
          expect(c.habitats).to match_array [{ 'forest' => { 'subhabitat' => 'coniferous', 'species' => ['picea'], 'habitat' => 'forest' } }, { 'meadow' => { 'habitat' => 'meadow' } }]
          expect(c.substrates).to match_array %w(litter living_tree)
          expect(c.fruiting_body['en'].blank?).to be_truthy
          expect(c.fruiting_body['sr']).to eq 'fr body sr'
        end
      end

      context 'with invalid params' do
        it 'does not create new characteristic' do
          old_characteristics_count = species.characteristics.count
          expect(old_characteristics_count).to eq 0

          response = post :create, species_url: species.url, format: :js, characteristic: { edible: '0' }

          expect(response.status).to eq 204
          expect(species.characteristics.count).to eq 0
        end
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :post, :create, '{species_url: species.url, characteristic: {edible: "0"}}', :js
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :post, :create, '{species_url: species.url}', :js
    end
  end


  describe 'PATCH #update' do
    let!(:characteristic) { FactoryGirl.create(:characteristic) }

    context 'when signed in as supervisor' do
      login_supervisor

      context 'with valid params' do
        it 'updates characteristic' do
          expect(characteristic.species.characteristics.count).to eq 1

          valid_params = {
            reference_id: characteristic.reference.id,
            edible: '0',
            cultivated: '1',
            poisonous: '0',
            medicinal: '0',
            habitats: {
              '1465143214' => {
                'forest' => {
                  'subhabitat' => 'coniferous',
                  'species' => ['picea'],
                  'habitat' => 'forest' } },
              '1465143231' => {
                'meadow' => {
                  'habitat' =>
                    'meadow' } } },
            substrates: ['', 'litter', 'living_tree'],
            fruiting_body: { 'sr' => 'fr body sr', 'en' => '' },
            microscopy: { 'sr' => '', 'en' => 'microscopy en' },
            flesh: { 'sr' => '', 'en' => '' },
            chemistry: { 'sr' => '', 'en' => '' },
            note: { 'sr' => '', 'en' => '' }
          }

          response = patch :update, species_url: species.url, id: characteristic.id, format: :js, characteristic: valid_params

          expect(response).to be_success
          expect(assigns(:characteristics)).to eq characteristic.species.characteristics
          expect(characteristic.species.characteristics.count).to eq 1
          expect(response).to render_template(:index)

          characteristic.reload
          expect(characteristic.cultivated).to be_truthy
          [:edible, :poisonous, :medicinal].each { |u| expect(characteristic.send(u)).to be_falsey }
          expect(characteristic.habitats).to match_array [{ 'forest' => { 'subhabitat' => 'coniferous', 'species' => ['picea'], 'habitat' => 'forest' } }, { 'meadow' => { 'habitat' => 'meadow' } }]
          expect(characteristic.substrates).to match_array %w(litter living_tree)
          expect(characteristic.fruiting_body['en'].blank?).to be_truthy
          expect(characteristic.fruiting_body['sr']).to eq 'fr body sr'
        end
      end

      context 'with invalid params' do
        it 'does not update characteristic' do
          response = patch :update, species_url: species.url, id: characteristic.id, format: :js, characteristic: { reference_id: nil }

          expect(response.status).to eq 204
          expect(species.characteristics.count).to eq 0
        end
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :patch, :update, '{species_url: species.url, id: characteristic.id, characteristic: {edible: "0"}}', :js
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :patch, :update, '{species_url: species.url, id: characteristic.id}', :js
    end
  end

  describe 'DELETE #destroy' do
    let!(:characteristic) { FactoryGirl.create(:characteristic) }

    context 'when signed in as supervisor' do
      login_supervisor

      context 'when successful' do
        it 'destroys characteristic' do
          species = characteristic.species
          expect(species.characteristics.count).to eq 1

          response = delete :destroy, species_url: species.url, id: characteristic.id, format: :js

          expect(response).to be_success
          expect(assigns(:characteristics)).to eq species.characteristics
          expect(species.characteristics.count).to eq 0
          expect(response).to render_template(:index)

          expect{characteristic.reload}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when unsuccessful' do
        it 'does not destroy characteristic' do
          species = characteristic.species
          expect(species.characteristics.count).to eq 1

          expect_any_instance_of(Characteristic).to receive(:destroy).and_return(false)

          response = delete :destroy, species_url: species.url, id: characteristic.id, format: :js

          expect(response.status).to eq 204
          expect(species.characteristics.count).to eq 1
          expect{characteristic.reload}.not_to raise_error
        end
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :delete, :destroy, '{species_url: species.url, id: characteristic.id}', :js
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :delete, :destroy, '{species_url: species.url, id: characteristic.id}', :js
    end
  end
end