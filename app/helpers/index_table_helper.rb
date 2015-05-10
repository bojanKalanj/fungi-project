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
end