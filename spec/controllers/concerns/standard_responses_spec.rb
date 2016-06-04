# describe ApplicationController, type: :controller do
#
#   controller do
#     include StandardResponses
#
#     before_action :set_user
#
#     def show
#       standard_nil_record_response(User)
#     end
#
#     def create
#       standard_create_response current_resource, current_resource.save, fields: [
#         { name: :first_name },
#         { name: :last_name },
#         { name: :email },
#         { name: :password, as: :string },
#         { name: :password_confirmation, as: :string }
#       ]
#     end
#
#     def standard_update
#       standard_update_response current_resource, current_resource.update(resource_params), fields: @fields
#     end
#
#     def standard_destroy
#       standard_destroy_response(current_resource, current_resource.destroy, source: params['source'])
#     end
#
#     private
#
#     def set_user
#       if action_name.to_sym == :new
#         @user = User.new
#       elsif action_name.to_sym == :create
#         @user = User.new(resource_params)
#       elsif action_name.to_sym == :index
#         @users = User.all
#       else
#         @user = User.friendly.find(params[:id])
#       end
#     end
#
#     def resource_params
#       puts params.inspect
#       params[:user]
#     end
#
#     def current_resource
#       @user
#     end
#   end
#
#
#   describe 'standard_nil_record_response' do
#     context 'when format is html' do
#       it 'redirects to index path' do
#         expect_any_instance_of(User).to receive(:resource_name_index_path).and_call_original
#         expect_any_instance_of(User).to receive(:resource_name).and_call_original
#         response = get :show, id: 1
#         expect(response).to redirect_to admin_users_path
#       end
#     end
#     context 'when format is html' do
#       it 'responds with empty response (no head)' do
#         response = get :show, id: 1, format: :json
#         expect(response.status).to eq 204
#       end
#     end
#   end
#
#   describe 'standard_create_response' do
#     it '' do
#       u = FactoryGirl.aliases_for(:user)
#       response = post :create, user: u
#
#       puts response.inspect
#     end
#   end
# end