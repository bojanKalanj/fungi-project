module ApplicationHelper

  def localized_url_helper(locale, args={})
    if admin_page?
      :species_index_path
    elsif root_page?
      if locale == I18n.default_locale
        :root_path
      else
        "root_#{locale}_path".to_sym
      end
    else
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

  def admin_page?
    request.env['PATH_INFO'].include? '/admin/'
  end

  def root_page?
    [root_path, root_en_path, root_sr_path].include? request.env['PATH_INFO']
  end

end
