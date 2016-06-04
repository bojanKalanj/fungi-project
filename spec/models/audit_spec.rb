require 'rails_helper'

RSpec.describe Audit, type: :model do
  subject { FactoryGirl.create(:audit) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

end

# == Schema Information
#
# Table name: audits
#
#  id              :integer          not null, primary key
#  auditable_id    :integer
#  auditable_type  :string(255)
#  associated_id   :integer
#  associated_type :string(255)
#  user_id         :integer
#  user_type       :string(255)
#  username        :string(255)
#  action          :string(255)
#  audited_changes :text(65535)
#  version         :integer          default(0)
#  comment         :string(255)
#  remote_address  :string(255)
#  request_uuid    :string(255)
#  created_at      :datetime
#
# Indexes
#
#  associated_index              (associated_id,associated_type)
#  auditable_index               (auditable_id,auditable_type)
#  index_audits_on_created_at    (created_at)
#  index_audits_on_request_uuid  (request_uuid)
#  user_index                    (user_id,user_type)
#
