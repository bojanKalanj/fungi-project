module SpeciesHelper

  def species_card(species)
    content_tag(:div, class: 'species-card') do
      concat content_tag(:span, class: 'btn btn-default btn-circle systematics_icon') {
        fo_icon_tag(:systematics, title: species.systematics.reverse.join(' '))
      }
      concat content_tag(:span, class: 'btn btn-default btn-circle specimen_count', title: t('species_search.specimens_count')) { species.specimens.length.to_s }
      concat image_tag('fungiorbis192.png')
      concat link_to(species.full_name, species_path(species, locale: I18n.locale), class: 'species-title')
      concat content_tag(:div, class: 'species-characteristics') { raw short_combined_characteristics(species) }
    end
  end

  def short_combined_characteristics(species)
    output = ''

    characteristics = species.combined_characteristics

    Characteristic::FLAGS.each do |flag|
      unless characteristics[flag].empty?
        output << fo_icon_tag(flag, title: t("characteristic.attributes.#{flag}"), class: flag)
      end
    end

    characteristics[:habitats].map { |h_hash| h_hash[:value] }.flatten.map do |h|
      habitat_key = h.keys.first
      title = h[habitat_key]['subhabitat'] ? t("habitats.#{habitat_key}.subhabitat.#{h[habitat_key]['subhabitat']}.title") : t("habitats.#{habitat_key}.title")
      species_names = h[habitat_key]['species'].blank? ? '' : h[habitat_key]['species'].map { |s| localized_habitat_species_name(s) }.join(', ')
      output << fo_icon_tag(:habitat, class: habitat_key, title: title + ' - ' + species_names)
    end

    characteristics[:substrates].map { |s| s[:value] }.flatten.uniq.each do |s|
      output << fo_icon_tag(:substrate, class: s, title: t("substrates.#{s}"))
    end

    output
  end
end