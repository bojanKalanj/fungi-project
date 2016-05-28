class AddLocaleToLocalizedPage < ActiveRecord::Migration
  def change
    add_column :localized_pages, :locale, :string, default: 'sr'
    LocalizedPage.all.each { |p| p.update_attribute :locale, p.language.locale }
  end
end
