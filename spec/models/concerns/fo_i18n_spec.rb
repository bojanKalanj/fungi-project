RSpec.describe FoI18n do
  include FoI18n

  after(:each) do
    I18n.locale = I18n.default_locale
  end

  describe 't' do
    context 'when localizing :en' do
      before(:each) do
        I18n.locale = :en
      end

      it 'calls I18n method directly' do
        expect(I18n).to receive(:translate!).with('time.pm', {}).and_call_original
        expect(t('time.pm')).to eq 'pm'
      end
    end

    context 'when localizing :sr' do
      before(:each) do
        I18n.locale = :sr
      end

      it 'calls I18n method directly' do
        expect(I18n).to receive(:translate!).with('time.pm', {}).and_call_original
        expect(t('time.pm')).to eq 'ПМ'
      end
    end

    context 'when localizing :sr-Latn' do
      before(:each) do
        I18n.locale = :'sr-Latn'
      end

      it 'calls localizes to sr and then transliterates' do
        expect(I18n).to receive(:translate!).with('time.pm', {}).and_call_original
        expect(I18n).to receive(:translate!).with('time.pm', { :locale => :sr }).and_call_original
        expect(t('time.pm')).to eq 'PM'
      end
    end
  end


  describe 'l' do
    context 'when localizing :en' do
      before(:each) do
        I18n.locale = :en
      end

      it 'calls I18n method directly' do
        expect(I18n).to receive(:localize).with(Time.new(2014), format: :short).and_call_original
        expect(l(Time.new(2014), format: :short)).to eq '01 Jan 00:00'
      end
    end

    context 'when localizing :sr' do
      before(:each) do
        I18n.locale = :sr
      end

      it 'calls I18n method directly' do
        expect(I18n).to receive(:localize).with(Time.new(2014), format: :short).and_call_original
        expect(l(Time.new(2014), format: :short)).to eq '01 Јан 00:00'
      end
    end

    context 'when localizing :sr-Latn' do
      before(:each) do
        I18n.locale = :'sr-Latn'
      end

      it 'calls localizes to sr and then transliterates' do
        expect(I18n).to receive(:localize).with(Time.new(2014), format: :short).and_call_original
        expect(I18n).to receive(:localize).with(Time.new(2014), { format: :short, :locale => :sr }).and_call_original
        expect(l(Time.new(2014), format: :short)).to eq '01 Jan 00:00'
      end
    end
  end
end