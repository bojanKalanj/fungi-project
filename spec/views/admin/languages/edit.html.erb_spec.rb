require 'rails_helper'

RSpec.describe "languages/edit", type: :view do
  before(:each) do
    @language = assign(:language, Language.create!(
      :name => "MyString",
      :slug_2 => "MyString",
      :slug_3 => "MyString"
    ))
  end

  it "renders the edit language form" do
    render

    assert_select "form[action=?][method=?]", admin_language_path(@language), "post" do

      assert_select "input#language_name[name=?]", "language[name]"

      assert_select "input#language_slug_2[name=?]", "language[slug_2]"

      assert_select "input#language_slug_3[name=?]", "language[slug_3]"
    end
  end
end
