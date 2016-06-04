# args = { 
#   class: <Class>, 
#   resource_name: <String>
# }
RSpec.shared_examples 'resource name' do |args|

  describe 'ClassMethods' do
    specify { expect(args[:class].resource_name).to eq args[:resource_name] }
  end

  describe 'resource_title' do
    it 'is implemented in the model' do
      expect { subject.resource_title }.not_to raise_error
    end
  end

end