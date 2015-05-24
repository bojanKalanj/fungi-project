require 'fungiorbis/cyr_to_lat'

module ApplicationHelper

  def localized_url_helper(locale, options={})
    if admin_page? || devise_page? || root_page?
      if locale == I18n.default_locale
        :root_path
      else
        "root_#{locale}_path".downcase.gsub('-', '_').to_sym
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
          if args[:controller] == 'localized_pages' && @localized_page
            ["#{args[:controller][0..-2]}_url".to_sym, @localized_page.for_locale(locale).title]
          elsif args[:controller][-1] == 's'
            ["#{args[:controller]}_url".to_sym, locale: locale]
          else
            ["#{args[:controller][0..-2]}_url".to_sym, locale: locale]
          end
      end
    end
  end

  def language_picker_url(locale)
    args = Rails.application.routes.recognize_path request.env['PATH_INFO']
    if args[:controller] == 'localized_pages' && @localized_page && !@localized_page.first?
      "/#{@localized_page.for_locale(locale).title}"
    else
      locale.to_sym == I18n.default_locale ? '/' : "/#{locale}"
    end
  end

  def is_species_search?
    args = Rails.application.routes.recognize_path request.env['PATH_INFO']
    args[:controller] == 'species' && args[:action] == 'search'
  end

  def admin_page?
    request.env['PATH_INFO'].include? '/admin/'
  end

  def devise_page?
    request.env['PATH_INFO'].include? '/users/'
  end

  def root_page?
    [root_path, root_en_path, root_sr_path].include? request.env['PATH_INFO']
  end


  def localized_tabs(form_builder, content_partial, localized_page_fields={})
    navs_tabs = []
    content_tabs = []

    form_builder.object.localized_pages.each_with_index do |localized_page, index|
      language = localized_page.language

      # localized_page_fields gets altered in a helper method used later, but it needs to be the same for each iteration
      fields = localized_page_fields.deep_dup

      id = "#{language.locale.parameterize}_#{localized_page.slug}"

      nav = content_tag :li, role: 'presentation', class: (index == 0 ? 'active' : '') do
        caption = "<i class='flag-icon flag-icon-#{language.flag}'></i> #{language.name}"
        link_to caption.html_safe, "##{id}", 'aria-controls' => id, role: 'tab', data: { toggle: 'tab' }
      end
      navs_tabs << nav

      content = content_tag :div, id: "#{id}", role: 'tabpanel', class: (index == 0 ? 'tab-pane active' : 'tab-pane') do
        render partial: content_partial, locals: { pf: form_builder, localized_page: localized_page, localized_page_fields: fields }
      end
      content_tabs << content
    end

    content_tag(:ul, class: 'localized-nav-tabs nav nav-tabs', role: 'tablist') { raw navs_tabs.join } +
      content_tag(:div, class: 'localized-tab tab-content') { raw content_tabs.join }
  end


  def localized_tabs_preview(page, content_partial, options={})
    navs_tabs = []
    content_tabs = []

    page.localized_pages.each_with_index do |localized_page, index|
      language = localized_page.language

      nav = content_tag :li, role: 'presentation', class: (index == 0 ? 'active' : '') do
        caption = "<i class='flag-icon flag-icon-#{language.flag}'></i> #{language.name}"
        link_to caption.html_safe, "##{localized_page.slug}", 'aria-controls' => localized_page.slug, role: 'tab', data: { toggle: 'tab' }
      end
      navs_tabs << nav

      content = content_tag :div, id: "#{localized_page.slug}", role: 'tabpanel', class: (index == 0 ? 'tab-pane active' : 'tab-pane') do
        render partial: content_partial, locals: { page: page, localized_page: localized_page }
      end
      content_tabs << content
    end

    content_tag(:ul, class: 'localized-nav-tabs nav nav-tabs', role: 'tablist') { raw navs_tabs.join } +
      content_tag(:div, class: 'localized-tab tab-content') { raw content_tabs.join }
  end


  def t(str, args={})
    I18n.translate!(str, args)
  rescue Exception => e
    if I18n.locale == :'sr-Latn'
      cyr_to_lat(I18n.translate!(str, args.merge(locale: :sr)))
    else
      raise e
    end
  end


  def parent_locale_for_current
    @parent_locale_for_current ||= Language.parent_locale_for_current
  end

  def l!(value, args={})
    if I18n.locale == parent_locale_for_current
      l(value, args)
    else
      cyr_to_lat l(value, args.merge({ locale: parent_locale_for_current }))
    end
  end

  def fo_icon_tag(type, args={})
    klass = args[:class].to_s + ' ' + fo_icon(type, args)
    content_tag :i, '', class: klass, title: args[:title]
  end

  def fo_icon(type, args={})
    case type
      when :species
        'fa fa-fw fa-book'
      when :specimens, :specimen
        'fa fa-fw fa-tags'
      when :references, :reference
        'fa fa-fw fa-quote-left'
      when :locations, :location
        'fa fa-fw fa-globe'
      when :field_studies
        'fa fa-fw fa-car'
      when :users, :user
        args[:singular] ? 'fa fa-fw fa-user' : 'fa fa-fw fa-users'
      when :user_add, :new
        'fa fa-fw fa-plus'
      when :characteristics, :characteristic
        'fa fa-fw fa-star'

      when :edible
        'fa fa-fw fa-cutlery'
      when :cultivated
        'fa fa-fw fa-thumbs-o-up'
      when :medicinal
        'fa fa-fw fa-heart-o'
      when :poisonous
        'fa fa-fw fa-exclamation-triangle'

      when :fruiting_body
        'fa fa-fw fa-lemon-o'
      when :microscopy
        'fa fa-fw fa-search'
      when :flesh
        'fa fa-fw fa-asterisk'
      when :chemistry
        'fa fa-fw fa-flask'
      when :note
        'fa fa-fw fa-star'

      when :sample, :samples
        'fa fa-fw fa-star'
      when :languages, :language
        'fa fa-fw fa-comments'
      when :pages, :page
        'fa fa-fw fa-file-text-o'
      when :sign_in
        'fa fa-fw fa-sign-in'
      when :sign_out
        'fa fa-fw fa-sign-out'
      when :admin
        'fa fa-fw fa-cogs'
      when :dashboard
        'fa fa-fw fa-dashboard'
      when :caret_down
        'fa fa-fw fa-caret-down'
      when :flag
        'fa fa-fw fa-flag'
      when :external_link
        'fa fa-fw fa-external-link'
      when :mail
        'fa fa-fw fa-envelope-o'
      when :yes, :true
        'fa fa-fw fa-check'

      when :habitat, :habitats
        'fa fa-fw fa-tree'
      when :substrate, :substrates
        'fa fa-fw fa-leaf'
      when :nutritive_group
        'fa fa-fw fa-certificate'
      when :growth_type
        'fa fa-fw fa-cubes'
      when :systematics
        'fa fa-fw fa-book'

      when :statistics
        'fa fa-fw fa-bar-chart-o'
      when :photos, :photo
        'fa fa-fw fa-camera'

      when :edit
        'fa fa-fw fa-edit'
      when :show
        'fa fa-fw fa-file-archive-o'
      when :delete, :remove
        'fa fa-fw fa-trash-o'
      when :cancel, :no, :false
        'fa fa-fw fa-times'
      else
        raise "unknown icon '#{type}'"
    end
  end

  def cyr_to_lat(str)
    Fungiorbis::CyrToLat.transliterate str
  end
end