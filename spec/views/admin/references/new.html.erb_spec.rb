require 'rails_helper'

RSpec.describe "references/new", type: :view do
  before(:each) do
    assign(:reference, Reference.new())
  end

  it "renders new reference form" do
    render

    assert_select "form[action=?][method=?]", admin_references_path, "post" do
    end
  end
end
