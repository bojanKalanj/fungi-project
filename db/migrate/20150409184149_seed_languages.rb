class SeedLanguages < ActiveRecord::Migration
  def change
    l = Language.new
    l.name = 'Serbian'
    l.slug_2 = 'sr'
    l.slug_3 = 'srp'
    l.default = true
    l.save!

    l = Language.new
    l.name = 'English'
    l.slug_2 = 'en'
    l.slug_3 = 'eng'
    l.save!
  end
end
