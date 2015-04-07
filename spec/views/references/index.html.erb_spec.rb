require 'rails_helper'

RSpec.describe "references/index", type: :view do
  before(:each) do
    assign(:references, [
      Reference.create!(),
      Reference.create!()
    ])
  end

  it "renders a list of references" do
    render
  end
end
