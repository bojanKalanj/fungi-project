module FungiorbisHelper

  def habitat_to_icon(h)
    if h.is_a?(String)
      title = h
    else
      habitat = h.keys.first

      if h[habitat]['subhabitat']
        title = t("habitats.#{habitat}.subhabitat.#{h[habitat]['subhabitat']}.title")
      else
        title = t("habitats.#{habitat}.title")
      end

    end
    fo_icon_tag(:habitat, title: title)
  end

end