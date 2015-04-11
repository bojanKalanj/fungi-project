require 'rails_helper'

RSpec.describe "species/edit", type: :view do
  before(:each) do
    @species = assign(:species, Species.create!())
  end

  it "renders the edit species form" do
    render

    assert_select "form[action=?][method=?]", admin_species_path(@species), "post" do
    end
  end
end
