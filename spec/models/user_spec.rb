RSpec.describe User, type: :model do
  subject { FactoryGirl.create(:user) }

  it_behaves_like 'resource name', {
    class: User,
    resource_name: 'user'
  }

  it_behaves_like 'resource paths', {
    class: User,
    resource_name_index_path: 'admin_users_path',
    resource_new_path: 'new_admin_user_path'
  }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  describe 'concerns' do
    it { expect(subject.class.ancestors.include? ResourceName).to be_truthy }
    it { expect(subject.class.ancestors.include? ResourcePaths).to be_truthy }
    it { expect(subject.class.ancestors.include? AuditCommentable).to be_truthy }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    it { is_expected.to validate_inclusion_of(:role).in_array(User::ROLES) }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  title                  :string(255)
#  role                   :string(255)      default("user"), not null
#  institution            :string(255)
#  phone                  :string(255)
#  slug                   :string(255)      not null
#  authentication_token   :string(255)
#  deactivated_at         :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  about                  :text(65535)
#  avatar_pic             :text(65535)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
