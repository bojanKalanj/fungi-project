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
end