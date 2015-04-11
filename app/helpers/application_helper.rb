module ApplicationHelper

  def localized_url_helper(locale, args={})
    args = Rails.application.routes.recognize_path request.env['PATH_INFO']

    case args[:action]
      when 'index'
        if %w(species).include? args[:controller]
          "#{args[:controller]}_index_#{locale}_path".to_sym
        else
          "#{args[:controller]}_#{locale}_path".to_sym
        end
      when 'new'
        "new_#{args[:controller]}_#{locale}_path".to_sym
      when 'edit'
        "edit_#{args[:controller]}_#{locale}_path".to_sym
      else
        "#{args[:controller]}_#{locale}_path".to_sym
    end
  end

end
