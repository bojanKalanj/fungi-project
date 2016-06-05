# args = {
#   class: <Class>,
#   plural: <Symbol>
# }

RSpec.shared_examples 'admin controller' do |args|

  describe 'GET #index' do
    context 'when signed in as supervisor' do
      login_supervisor

      it "lists #{args[:plural]}" do
        response = get :index
        expect(response).to be_success
        expect(assigns(args[:plural])).to eq args[:class].all
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
    context 'when signed in as supervisor' do
      login_supervisor

      it "shows #{args[:singular]}" do
        response = get :show, eval(args[:params])
        expect(response).to be_success
        expect(assigns(args[:singular])).to eq record
        expect(response).to render_template(:show)
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :show, args[:params]
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :show, args[:params]
    end
  end

  describe 'GET #new' do
    context 'when signed in as supervisor' do
      login_supervisor

      it "shows new #{args[:singular]} form" do
        response = get :new
        expect(response).to be_success
        expect(assigns(args[:singular]).new_record?).to be_truthy
        expect(response).to render_template(:new)
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :new, {}
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :new, {}
    end
  end

  describe 'GET #edit' do
    context 'when signed in as supervisor' do
      login_supervisor

      it "shows edit #{args[:singular]} form" do
        response = get :edit, eval(args[:params])
        expect(response).to be_success
        expect(assigns(args[:singular])).to eq record
        expect(response).to render_template(:edit)
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :get, :edit, args[:params]
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :get, :edit, args[:params]
    end
  end

  describe 'POST #create' do
    context 'when signed in as supervisor' do
      login_supervisor

      context 'with valid params' do
        it "creates new #{args[:singular]}" do
          response = post :create, args[:singular] => eval(args[:valid_params])
          new_record = args[:class].all.last

          expect(response).to redirect_to(new_record.resource_name_path)
          expect(assigns(args[:singular])).to eq new_record
        end
      end

      context 'with invalid params' do
        it "does not create new #{args[:singular]}" do
          response = post :create, args[:singular] => eval(args[:params])

          expect(response.status).to eq 422
          expect(response).to render_template(:new)
        end
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :post, :create, "{id: record.id, record.resource_name_sym => #{args[:valid_params]}}"
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :post, :create, args[:params]
    end
  end

  describe 'PATCH #update' do
    context 'when signed in as supervisor' do
      login_supervisor

      context 'with valid params' do
        it "updates #{args[:singular]}" do
          response = patch :update, eval(args[:params]).merge(args[:singular] => record.attributes)

          expect(response).to redirect_to(record.resource_name_path)
          expect(assigns(args[:singular])).to eq record
        end
      end

      context 'with invalid params' do
        it "does not update #{args[:singular]}" do
          h = record.attributes
          (h.keys-['id']).each { |key| h[key] = nil }
          response = patch :update, eval(args[:params]).merge(args[:singular] => h)

          expect(response.status).to eq 422
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :patch, :update, "{#{args[:params].gsub('{', '').gsub('}', '')}, record.resource_name_sym => #{args[:params]}}"
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :patch, :update, args[:params]
    end
  end

  describe 'DELETE #destroy' do
    context 'when signed in as supervisor' do
      login_supervisor

      context 'with valid params' do
        it "destroys #{args[:singular]}" do
          response = delete :destroy, eval(args[:params])

          expect(response).to redirect_to(record.resource_name_index_path)
          expect { record.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'with invalid params' do
        it "does not destroy #{args[:singular]}" do
          expect_any_instance_of(args[:class]).to receive(:destroy).and_return(false)
          response = delete :destroy, eval(args[:params])

          expect { record.reload }.not_to raise_error
          expect(response).to redirect_to(record.resource_name_path)
        end
      end
    end

    context 'with user or contributor' do
      it_behaves_like 'forbidden for non supervisors', :delete, :destroy, "{#{args[:params].gsub('{', '').gsub('}', '')}, record.resource_name_sym => #{args[:params]}}"
    end

    context 'with non authenticated user' do
      it_behaves_like 'unauthorized for non authenticated users', :delete, :destroy, args[:params]
    end
  end

  context 'methods that need to be implemented' do
    specify { expect(subject.class.private_method_defined?(:current_resource)).to be_truthy }
    specify { expect(subject.class.private_method_defined?(:resource_params)).to be_truthy }
  end
end