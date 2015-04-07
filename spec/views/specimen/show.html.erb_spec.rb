require 'rails_helper'

RSpec.describe "specimen/show", type: :view do
  before(:each) do
    @specimen = assign(:specimen, Specimen.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
