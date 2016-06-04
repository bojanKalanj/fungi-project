module AuditCommentable
  extend ActiveSupport::Concern

  def after_audit
    Audit.find(self.audits.last.id).add_display_name_to_comment
  end
end