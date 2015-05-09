module Resource
  extend ActiveSupport::Concern

  included do
  end

  def resource_name
    self.class.name.underscore
  end

  def resource_name_sym
    self.resource_name.to_sym
  end

  def resource_name_index_path
    "admin_#{self.resource_name[-1] == 's' ? self.resource_name + '_index' : self.resource_name}_path".to_sym
  end

  def resource_name_path
    "admin_#{self.resource_name}_path".to_sym
  end

  def resource_title
    raise "resource_title method not implemented for model: #{self.class.name}"
  end
end