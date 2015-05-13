module IndexTableHelper

  def wrap_in_link(value, options={})
    options ||= {}

    if options[:external]
      link_to value, target: :_blank do
        raw value.gsub('http://', '').gsub('https://', '') + '  ' + fo_icon_tag(:external_link)
      end
    else
      link_to value, value
    end
  end

  def wrap_in_mail_to(value, options={})
    options ||= {}

    raw(value + '  ' + link_to("mailto:#{value}") { fo_icon_tag(:mail) })
  end

  def boolean_to_icon(value, options={})
    options ||= {}
    value ? fo_icon_tag(:true) : fo_icon_tag(:false)
  end

  def parse_flag(value, options={})
    options ||= {}
    content_tag :span, '', class: "flag-icon flag-icon-#{value}"
  end

  def translate_value(value, options={})
    options ||= {}
    options = options[:options] if options[:options]

    t(value, options)
  end

  def localize_date(value, options)
    options ||= {}
    options = options[:options] if options[:options]

    l!(value, options)
  end

  def short_characteristics(values, options)
    output = ''
    values.each do |value|
      output += fo_icon_tag(value, title: t("characteristic.attributes.#{value}"), class: :pointer)
    end
    raw output
  end

  def long_characteristics(values, options)
    output = ''
    values.each do |value|
      key = value.keys.first
      title = t("characteristic.attributes.#{key}") + ': ' + value[key]
      output += fo_icon_tag(key, title: title, class: :pointer)
    end
    raw output
  end

  def localized_characteristic_preview(value, options)
    navs_tabs = []
    content_tabs = []

    value.keys.each_with_index do |locale, index|
      language = Language.where(locale: locale).first

      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      id = (0...50).map { o[rand(o.length)] }.join

      nav = content_tag :li, role: 'presentation', class: (index == 0 ? 'active' : '') do
        caption = "<i class='flag-icon flag-icon-#{language.flag}'></i> #{language.title}"
        link_to caption.html_safe, "##{id}-#{locale}", 'aria-controls' => "#{id}-#{locale}", role: 'tab', data: { toggle: 'tab' }
      end
      navs_tabs << nav

      content = content_tag(:div, id: "#{id}-#{locale}", role: 'tabpanel', class: (index == 0 ? 'tab-pane active' : 'tab-pane')) { value[locale].blank? ? '-' : value[locale] }
      content_tabs << content
    end

    content_tag(:ul, class: 'localized-nav-tabs nav nav-tabs', role: 'tablist') { raw navs_tabs.join } +
      content_tag(:div, class: 'localized-tab tab-content') { raw content_tabs.join }
  end
end