module ResourceName
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def resource_name
      self.name.underscore
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

end