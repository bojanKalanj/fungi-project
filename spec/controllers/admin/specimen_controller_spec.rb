require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe SpecimenController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Specimen. As you add validations to Specimen, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SpecimenController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all specimen as @specimen" do
      specimen = Specimen.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:specimen)).to eq([specimen])
    end
  end

  describe "GET #show" do
    it "assigns the requested specimen as @specimen" do
      specimen = Specimen.create! valid_attributes
      get :show, {:id => specimen.to_param}, valid_session
      expect(assigns(:specimen)).to eq(specimen)
    end
  end

  describe "GET #new" do
    it "assigns a new specimen as @specimen" do
      get :new, {}, valid_session
      expect(assigns(:specimen)).to be_a_new(Specimen)
    end
  end

  describe "GET #edit" do
    it "assigns the requested specimen as @specimen" do
      specimen = Specimen.create! valid_attributes
      get :edit, {:id => specimen.to_param}, valid_session
      expect(assigns(:specimen)).to eq(specimen)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Specimen" do
        expect {
          post :create, {:specimen => valid_attributes}, valid_session
        }.to change(Specimen, :count).by(1)
      end

      it "assigns a newly created specimen as @specimen" do
        post :create, {:specimen => valid_attributes}, valid_session
        expect(assigns(:specimen)).to be_a(Specimen)
        expect(assigns(:specimen)).to be_persisted
      end

      it "redirects to the created specimen" do
        post :create, {:specimen => valid_attributes}, valid_session
        expect(response).to redirect_to(Specimen.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved specimen as @specimen" do
        post :create, {:specimen => invalid_attributes}, valid_session
        expect(assigns(:specimen)).to be_a_new(Specimen)
      end

      it "re-renders the 'new' template" do
        post :create, {:specimen => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested specimen" do
        specimen = Specimen.create! valid_attributes
        put :update, {:id => specimen.to_param, :specimen => new_attributes}, valid_session
        specimen.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested specimen as @specimen" do
        specimen = Specimen.create! valid_attributes
        put :update, {:id => specimen.to_param, :specimen => valid_attributes}, valid_session
        expect(assigns(:specimen)).to eq(specimen)
      end

      it "redirects to the specimen" do
        specimen = Specimen.create! valid_attributes
        put :update, {:id => specimen.to_param, :specimen => valid_attributes}, valid_session
        expect(response).to redirect_to(specimen)
      end
    end

    context "with invalid params" do
      it "assigns the specimen as @specimen" do
        specimen = Specimen.create! valid_attributes
        put :update, {:id => specimen.to_param, :specimen => invalid_attributes}, valid_session
        expect(assigns(:specimen)).to eq(specimen)
      end

      it "re-renders the 'edit' template" do
        specimen = Specimen.create! valid_attributes
        put :update, {:id => specimen.to_param, :specimen => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested specimen" do
      specimen = Specimen.create! valid_attributes
      expect {
        delete :destroy, {:id => specimen.to_param}, valid_session
      }.to change(Specimen, :count).by(-1)
    end

    it "redirects to the specimen list" do
      specimen = Specimen.create! valid_attributes
      delete :destroy, {:id => specimen.to_param}, valid_session
      expect(response).to redirect_to(specimen_url)
    end
  end

end