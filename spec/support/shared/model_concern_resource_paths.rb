# args = { 
#   class: <Class>, 
#   resource_name_index_path: <String>,
#   resource_new_path: <String>
# }
RSpec.shared_examples 'resource paths' do |args|

  describe 'ClassMethods' do
    specify { expect(args[:class].resource_name_index_path).to eq(eval 'Rails.application.routes.url_helpers.' + args[:resource_name_index_path]) }
    specify { expect(args[:class].resource_new_path).to eq(eval 'Rails.application.routes.url_helpers.' + args[:resource_new_path]) }
  end

  describe 'resource paths' do
    specify { expect { subject.resource_name_path }.not_to raise_error }
    specify { expect { subject.resource_edit_path }.not_to raise_error }
    specify { expect { subject.resource_name_index_path }.not_to raise_error }
    specify { expect { subject.resource_new_path }.not_to raise_error }
  end

end