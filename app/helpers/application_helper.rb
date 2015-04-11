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


  def localized_tabs(form_builder, content_partial, options={})
    navs_tabs = []
    content_tabs = []

    form_builder.object.localized_pages.each_with_index do |localized_page, index|
      language = localized_page.language

      nav = content_tag :li, role: 'presentation', class: (index == 0 ? 'active' : '') do
        caption = "<i class='flag-icon flag-icon-#{language.flag}'></i> #{language.name}"
        link_to caption.html_safe, "##{localized_page.slug}", 'aria-controls' => localized_page.slug, role: 'tab', data: { toggle: 'tab' }
      end
      navs_tabs << nav

      content = content_tag :div, id: "#{localized_page.slug}", role: 'tabpanel', class: (index == 0 ? 'tab-pane active' : 'tab-pane') do
        render partial: content_partial, locals: { pf: form_builder, localized_page: localized_page }
      end
      content_tabs << content
    end

    content_tag(:ul, class: 'localized-nav-tabs nav nav-tabs', role: 'tablist') { raw navs_tabs.join } +
      content_tag(:div, class: 'localized-tab tab-content') { raw content_tabs.join }
  end

  def localized_tabs_preview(page, field_name, content_partial, options={})
    navs_tabs = []
    content_tabs = []
    Language.all.each_with_index do |language, index|
      localized_page = page.localized_pages.find_by_language_id(language.id)

      name = "#{field_name}_#{language.name.underscore}_#{page.id}"

      nav = content_tag :li, role: 'presentation', class: (index == 0 ? 'active' : '') do
        caption = "<i class='flag-icon flag-icon-#{language.flag}'></i> #{language.name}"
        link_to caption.html_safe, "##{name.parameterize}", 'aria-controls' => name, role: 'tab', data: { toggle: 'tab' }
      end
      navs_tabs << nav

      content_tab = content_tag :div, id: "#{name.parameterize}", role: 'tabpanel', class: (index == 0 ? 'tab-pane active' : 'tab-pane') do
        content = localized_page.send(field_name)
        render partial: content_partial, locals: { localized_string: content, code: language.locale, content: page }
      end
      content_tabs << content_tab
    end

    content_tag(:ul, class: 'nav nav-tabs', role: 'tablist') { raw navs_tabs.join } +
      content_tag(:div, class: 'tab-content') { raw content_tabs.join }
  end

end
