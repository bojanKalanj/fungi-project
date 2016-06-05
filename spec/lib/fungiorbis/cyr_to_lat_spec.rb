RSpec.describe Fungiorbis::CyrToLat do

  describe 'transliterate' do
    specify { expect(Fungiorbis::CyrToLat.transliterate('latinica')).to eq 'latinica' }
    specify { expect(Fungiorbis::CyrToLat.transliterate('ћирилица')).to eq 'ćirilica' }
    specify { expect(Fungiorbis::CyrToLat.transliterate(nil)).to eq '' }
  end

end