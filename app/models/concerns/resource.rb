module Resource
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def resource_name
      self.name.underscore
    end

    def resource_name_index_path
      path = "admin_#{resource_name[-1] == 's' ? resource_name + '_index' : resource_name + 's'}_path"
      Rails.application.routes.url_helpers.send(path.to_sym)
    end

    def resource_new_path
      Rails.application.routes.url_helpers.send("new_admin_#{resource_name}_path".to_sym)
    end

    def resource_action_path(action)
      if [:index, :cancel].include?(action)
        resource_name_index_path
      elsif action == :new
        resource_new_path
      else
        raise 'unknown action'
      end
    end
  end

  def resource_title
    raise "resource_title method not implemented for model: #{self.class.name}"
  end

  def resource_name
    self.class.name.underscore
  end

  def resource_name_sym
    self.resource_name.to_sym
  end

  def resource_action_path(action)
    if [:show, :delete, :update].include? action
      self.resource_name_path
    elsif action == :edit
      self.resource_edit_path
    else
      self.class.resource_action_path(action)
    end
  end

  def resource_name_path(options={})
    Rails.application.routes.url_helpers.send("admin_#{self.resource_name}_path".to_sym, self, options)
  end

  def resource_edit_path
    Rails.application.routes.url_helpers.send("edit_admin_#{self.resource_name}_path".to_sym, self)
  end

  def resource_name_index_path
    self.class.resource_name_index_path
  end

  def resource_new_path
    self.class.resource_new_path
  end

end