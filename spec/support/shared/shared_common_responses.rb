RSpec.shared_examples 'forbidden for non supervisors' do |method, action, params|
  [:user, :contributor].each do |user_by_role|
    context "when #{user_by_role}" do
      send(:"login_#{user_by_role}")

      context 'when format is html' do
        before(:each) do
          send(method, action, { format: :html }.merge(params.is_a?(String) ? eval(params) : params))
        end

        subject { response }
        it { is_expected.to redirect_to(root_url) }
        specify { expect(flash[:alert]).to eq I18n.t('unauthorized.default') }
      end
    end
  end
end

RSpec.shared_examples 'unauthorized for non authenticated users' do |method, action, params|
  context 'when format is html' do
    before(:each) do
      send(method, action, { format: :html }.merge(params.is_a?(String) ? eval(params) : params))
    end

    subject { response }
    it { is_expected.to redirect_to(new_user_session_path) }
  end
end