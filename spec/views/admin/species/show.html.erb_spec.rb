require 'rails_helper'

RSpec.describe "species/show", type: :view do
  before(:each) do
    @species = assign(:species, Species.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
