require 'rails_helper'

RSpec.describe "species/index", type: :view do
  before(:each) do
    assign(:species, [
      Species.create!(),
      Species.create!()
    ])
  end

  it "renders a list of species" do
    render
  end
end
