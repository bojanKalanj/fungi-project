RSpec.shared_examples 'forbidden for non supervisors' do |method, action, params, format|
  [:user, :contributor].each do |user_by_role|
    context "when #{user_by_role}" do
      send(:"login_#{user_by_role}")

      if format.nil? || Array(format).include?(:html)
        context 'when format is html' do
          before(:each) do
            send(method, action, { format: :html }.merge(params.is_a?(String) ? eval(params) : params))
          end

          subject { response }
          it { is_expected.to redirect_to(root_url) }
          specify { expect(flash[:alert]).to eq I18n.t('unauthorized.default') }
        end
      end

      if format && Array(format).include?(:js)
        context 'when format is js' do
          before(:each) do
            send(:xhr, method, action, { format: :js }.merge(params.is_a?(String) ? eval(params) : params))
          end

          specify { expect(response.status).to eq 403 }
        end
      end
    end
  end
end

RSpec.shared_examples 'unauthorized for non authenticated users' do |method, action, params, format|
  if format.nil? || Array(format).include?(:html)
    context 'when format is html' do
      before(:each) do
        send(method, action, { format: :html }.merge(params.is_a?(String) ? eval(params) : params))
      end

      subject { response }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  if format && Array(format).include?(:js)
    context 'when format is js' do
      before(:each) do
        send(:xhr, method, action, { format: :js }.merge(params.is_a?(String) ? eval(params) : params))
      end

      specify { expect(response.status).to eq 401 }
    end
  end
end