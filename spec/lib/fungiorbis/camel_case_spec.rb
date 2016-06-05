describe Fungiorbis::CamelCase do
  include Fungiorbis::CamelCase

  describe 'to_underscore' do
    context 'when String' do
      specify { expect(to_underscore('FooBar-BAR')).to eq 'foo_bar_bar' }
      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_underscore('FooBar-BAR', output: output)).to eq 'foo_bar_bar' }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_underscore('FooBar-BAR', output: output)).to eq :foo_bar_bar }
      end
    end

    context 'when Symbol' do
      specify { expect(to_underscore(:FooBar)).to eq :foo_bar }
      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_underscore(:FooBar, output: output)).to eq 'foo_bar' }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_underscore(:FooBar, output: output)).to eq :foo_bar }
      end
    end

    context 'when Array' do
      specify { expect(to_underscore(['FooBar-BAR', :FooBar])).to eq ['foo_bar_bar', :foo_bar] }
      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_underscore(['FooBar-BAR', :FooBar], output: output)).to eq ['foo_bar_bar', 'foo_bar'] }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_underscore(['FooBar-BAR', :FooBar], output: output)).to eq [:foo_bar_bar, :foo_bar] }
      end
    end

    context 'when Hash' do
      specify { expect(to_underscore({ 'FooBar-BAR' => :FooBar, BarFoo: 'BarBar' })).to eq ({ 'foo_bar_bar' => :FooBar, bar_foo: 'BarBar' }) }
      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_underscore({ 'FooBar-BAR' => :FooBar, BarFoo: 'BarBar' }, output: output)).to eq({ 'foo_bar_bar' => :FooBar, 'bar_foo' => 'BarBar' }) }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_underscore({ 'FooBar-BAR' => :FooBar, BarFoo: 'BarBar' }, output: output)).to eq({ foo_bar_bar: :FooBar, bar_foo: 'BarBar' }) }
      end
    end
  end


  describe 'to_camel_case' do
    context 'when String' do
      specify { expect(to_camel_case('foo_bar_bar')).to eq 'fooBarBar' }

      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_camel_case('foo_bar_bar', output: output)).to eq 'fooBarBar' }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_camel_case('foo_bar_bar', output: output)).to eq :fooBarBar }
      end
    end

    context 'when Symbol' do
      specify { expect(to_camel_case(:foo_bar)).to eq :fooBar }

      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_camel_case(:foo_bar, output: output)).to eq 'fooBar' }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_camel_case(:foo_bar, output: output)).to eq :fooBar }
      end
    end

    context 'when Array' do
      specify { expect(to_camel_case(['foo_bar_bar', :foo_bar])).to eq ['fooBarBar', :fooBar] }

      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_camel_case(['foo_bar_bar', :foo_bar], output: output)).to eq ['fooBarBar', 'fooBar'] }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_camel_case(['foo_bar_bar', :foo_bar], output: output)).to eq [:fooBarBar, :fooBar] }
      end
    end

    context 'when Hash' do
      specify { expect(to_camel_case({ 'foo_bar_bar' => :foo_bar, bar_foo: 'bar_bar' })).to eq ({ 'fooBarBar' => :foo_bar, barFoo: 'bar_bar' }) }
      [:string, :strings, 'string', 'strings'].each do |output|
        specify { expect(to_camel_case({ 'foo_bar_bar' => :foo_bar, bar_foo: 'bar_bar' }, output: output)).to eq({ 'fooBarBar' => :foo_bar, 'barFoo' => 'bar_bar' }) }
      end

      [:symbol, :symbols, 'symbol', 'symbols'].each do |output|
        specify { expect(to_camel_case({ 'foo_bar_bar' => :foo_bar, bar_foo: 'bar_bar' }, output: output)).to eq({ fooBarBar: :foo_bar, barFoo: 'bar_bar' }) }
      end
    end
  end
end