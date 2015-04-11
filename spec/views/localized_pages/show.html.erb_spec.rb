require 'rails_helper'

RSpec.describe "localized_pages/show", type: :view do
  before(:each) do
    @localized_page = assign(:localized_page, LocalizedPage.create!(
      :title => "Title",
      :content => "MyText",
      :slug => "Slug",
      :language => nil,
      :page => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
