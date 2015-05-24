module LastUpdate
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def last_update
      self.order('updated_at DESC').pluck(:updated_at).last
    end
  end
end