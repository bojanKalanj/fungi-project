class Audit < ActiveRecord::Base
  belongs_to :user

  class << self
    def for(id)
      where(auditable_id: id)
    end
  end

  def css_class
    case self.action
      when 'destroy'
        'danger'
      when 'update'
        'warning'
      else
        'info'
    end
  end

  def title
    action_i18n = I18n.t("admin.dashboard.audits.action.#{self.action}_#{gender}")
    I18n.t("admin.dashboard.audits.auditable_type.#{self.auditable_type.downcase}", action: action_i18n)
  end

  def record
    self.auditable_type.constantize.where(id: self.auditable_id).first
  end

  def add_display_name_to_comment
    record = self.record
    self.update_attribute :comment, record.audit_title if record
  end

  def localized_changes
    rows = self.audited_changes.split(/(<?^\w+):/).reject { |i| i=="---\n" }.map{ |item| item =~ /^-/ ? item.gsub(/^-\s/, '').split("\n").reject(&:empty?) : item }
    Hash[*rows]
  end

  def resource_title
    "#{self.title} - #{self.comment}"
  end

  def url(record=nil)
    record ||= self.record
    if record
      case self.auditable_type
        when 'Characteristic'
          Rails.application.routes.url_helpers.admin_species_characteristic_path species_url: record.species, id: self.auditable_id
        when 'Language'
          Rails.application.routes.url_helpers.admin_language_path(id: record.id)
        when 'LocalizedPage'
          Rails.application.routes.url_helpers.admin_language_path(id: record.id)
        when 'Location'
          Rails.application.routes.url_helpers.admin_location_path(id: record.id)
        when 'Page'
          Rails.application.routes.url_helpers.admin_page_path(id: record.id)
        when 'Reference'
          Rails.application.routes.url_helpers.admin_reference_path(id: record.id)
        when 'Species'
          Rails.application.routes.url_helpers.admin_species_path record
        when 'Specimen'
          Rails.application.routes.url_helpers.admin_specimen_path(id: record.id)
        when 'User'
          Rails.application.routes.url_helpers.admin_user_path(id: record.id)
        else
          nil
      end
    end
  end

  private

  def gender
    case self.auditable_type
      when 'Species', 'Characteristic', 'Location', 'Page', 'Reference'
        'f'
      when 'Language', 'Specimen', 'User', 'LocalizedPage'
        'm'
      else
        raise 'unknown auditable_type'
    end
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
