require 'rails_helper'

RSpec.describe "references/edit", type: :view do
  before(:each) do
    @reference = assign(:reference, Reference.create!())
  end

  it "renders the edit reference form" do
    render

    assert_select "form[action=?][method=?]", admin_reference_path(@reference), "post" do
    end
  end
end
