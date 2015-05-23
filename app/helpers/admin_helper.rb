module AdminHelper

  def admin_page_header(resource, action, options={})
    output = ''

    title = resource_title(resource, action)

    resource = resource.page if resource.is_a?(LocalizedPage)
    if current_user && current_user.supervisor?

      if [:new, :edit, :show].include?(action)
        cancel_path = action == :edit ? resource.resource_name_path : resource.resource_name_index_path
        output << admin_page_header_btn(:cancel, resource, class: 'btn-default', title: t('helpers.links.cancel'), path: cancel_path)
      end
      output << admin_page_header_btn(:new, resource, class: 'btn-primary') if [:index].include?(action)
      output << admin_page_header_btn(:edit, resource, class: 'btn-primary') if [:show].include?(action)
      output << admin_page_header_btn(:show, resource, class: 'btn-default') if [:edit].include?(action)
      output << admin_page_header_btn(:delete, resource, class: 'btn-danger', :method => :delete, :data => { :confirm => t('helpers.links.confirm') }) if [:edit, :show].include?(action)
    end

    title_class = nil
    title_class = options[:title][:class] if options[:title]

    content_tag(:div, class: 'page-header') do
      raw(output)+
        content_tag(:h1, class: title_class) do
          if options[:no_header_icon]
            title
          else
            fo_icon_tag(resource.resource_name.to_sym) + title
          end
        end
    end
  end

  def admin_page_resource_subheader(resource, action, options={})
    output = ''

    title = resource_title(resource, action)

    resource = resource.page if resource.is_a?(LocalizedPage)
    if current_user && current_user.supervisor?

      if [:new, :edit, :show].include?(action)
        cancel_path = options[:index_path] || (action == :edit ? resource.resource_name_path : resource.resource_name_index_path)
        output << admin_page_header_btn(:cancel, resource, class: 'btn-default', title: t('helpers.links.cancel'), path: cancel_path, remote: options[:remote])
      end
      output << admin_page_header_btn(:new, resource, class: 'btn-primary', path: options[:new_path], remote: options[:remote]) if [:index].include?(action)
      output << admin_page_header_btn(:edit, resource, class: 'btn-primary', path: options[:edit_path], remote: options[:remote]) if [:show].include?(action)
      output << admin_page_header_btn(:show, resource, class: 'btn-default', path: options[:path], remote: options[:remote]) if [:edit].include?(action)
      output << admin_page_header_btn(:delete, resource, class: 'btn-danger', path: options[:path], remote: options[:remote], :method => :delete, :data => { :confirm => t('helpers.links.confirm') }) if [:edit, :show].include?(action)
    end

    title_class = nil
    title_class = options[:title][:class] if options[:title]

    content_tag(:div, class: 'page-header subheader') do
      raw(output)+
        content_tag(:h2, class: title_class) do
          fo_icon_tag(resource.resource_name.to_sym) + title
        end
    end
  end

  def admin_show_field(resource, field, options={})
    options ||= {}
    value = resource.send(field)

    content_tag(:dt) do
      content_tag(:strong) do
        t("#{resource.resource_name}.attributes.#{field}") + ':'
      end
    end +
      content_tag(:dd) do
        if value.blank?
          '-'
        elsif options[:method]
          send(options[:method], value, options)
        else
          value.respond_to?(:resource_title) ? value.resource_title : value.to_s
        end
      end
  end

  def admin_show_fields(resource, fields, options={})
    output = ''
    fields.each { |field| output << admin_show_field(resource, field, options.select { |f| f[:name] == field }.first) }

    content_tag(:dl, class: 'dl-horizontal') do
      raw output
    end
  end

  def localized_tabs_field(form_object, field, options={})
    navs_tabs = []
    content_tabs = []

    current_language = Language.where(locale: I18n.locale).first
    current_language = Language.find(current_language.parent_id) if current_language.parent_id
    current_locale = current_language.locale

    form_object.simple_fields_for field do |f|
      Language.where('parent_id IS NULL').each do |language|

        id = "#{field}_#{language.locale}"

        nav = content_tag :li, role: 'presentation', class: (language.locale == current_locale ? 'active' : '') do
          caption = "<i class='flag-icon flag-icon-#{language.flag}'></i> #{language.title}"
          link_to caption.html_safe, "##{id}", 'aria-controls' => id, role: 'tab', data: { toggle: 'tab' }
        end
        navs_tabs << nav

        content = content_tag(:div, id: "#{id}", role: 'tabpanel', class: (language.locale == current_locale ? 'tab-pane active' : 'tab-pane')) do
          f.input language.locale, label: false, as: :text
        end
        content_tabs << content
      end
    end

    form_object.label(options[:label]) +
      content_tag(:ul, class: 'localized-nav-tabs nav nav-tabs', role: 'tablist') { raw navs_tabs.join } +
      content_tag(:div, class: 'localized-tab tab-content') { raw content_tabs.join }
  end

  def habitats_field(form_object, name, options)
    output = content_tag(:div, class: 'form-group') { form_object.label :habitats, label: t('characteristic.attributes.habitats'), requied: false }

    if form_object.object.send(name)
      form_object.object.send(name).each_with_index do |habitat_hash, index|
        habitat = habitat_hash.keys.first
        subhabitat = habitat_hash[habitat]['subhabitat']
        selected_species = habitat_hash[habitat]['species']

        subhabitats = subhabitat.blank? ? nil : subhabitat_keys(habitat).map { |key| [t("habitats.#{habitat}.subhabitat.#{key}.title"), key] }
        species = allowed_species(habitat, subhabitat).map { |key| [localized_habitat_species_name(key), key] }
        output += render partial: 'admin/shared/habitat_form', locals: { habitat: habitat, subhabitat: subhabitat, subhabitats: subhabitats, selected_species: selected_species, species: species, index: index }
      end
    end

    habitats = all_habitat_keys.map { |key| [t("habitats.#{key}.title"), key] }
    content_tag(:div, class: :habitats) { output } +
      content_tag(:div, class: 'form-group') do
        select_tag('habitats-select', options_for_select(habitats, nil), include_blank: false, data: { url: admin_habitats_path(habitat: '') }, prompt: t('characteristic.interface.add_habitat')) +
          link_to('', class: 'btn btn-primary btn-circle add-habitat', title: t('characteristic.interface.add_habitat'), remote: true) { fo_icon_tag(:new) }
      end
  end

  def habitat_field(form_object, name, options)
    output = content_tag(:div, class: 'form-group') { form_object.label :habitats, label: t('specimen.attributes.habitat'), requied: false }

    habitat = nil
    if form_object.object.send(name)
      habitat_hash = form_object.object.send(name)
      habitat_hash = { habitat_hash => habitat_hash } unless habitat_hash.is_a?(Hash)

      habitat = habitat_hash.keys.first
      subhabitat = habitat_hash[habitat]['subhabitat']
      selected_species = habitat_hash[habitat]['species']

      subhabitats = subhabitat.blank? ? nil : subhabitat_keys(habitat).map { |key| [t("habitats.#{habitat}.subhabitat.#{key}.title"), key] }
      species = allowed_species(habitat, subhabitat).map { |key| [localized_habitat_species_name(key), key] }
      output += render partial: 'admin/shared/specimen_habitat_form', locals: { habitat: habitat, subhabitat: subhabitat, subhabitats: subhabitats, selected_species: selected_species, species: species }
    end

    habitats = all_habitat_keys.map { |key| [t("habitats.#{key}.title"), key] }
    content_tag(:div, class: :habitats) { output } +
      content_tag(:div, class: "form-group #{'hidden' if habitat}") do
        select_tag('habitats-select', options_for_select(habitats, nil), include_blank: false, data: { url: admin_habitats_path(for_specimen: 1, habitat: '') }, prompt: t('characteristic.interface.add_habitat')) +
          link_to('', class: 'btn btn-primary btn-circle add-habitat', title: t('characteristic.interface.add_habitat'), remote: true, data: { max: 1 }) { fo_icon_tag(:new) }
      end
  end

  def substrates_field(form_object, name, options)
    content_tag(:div, class: 'form-group') do
      form_object.input :substrates, label: t('characteristic.attributes.substrates'), requied: false, collection: all_substrate_keys.map { |key| [t("substrates.#{key}"), key] }, label_method: :first, value_method: :last, input_html: { multiple: true }
    end
  end

  def admin_edit_field(resource, field, form_object, options={})
    options[:label] = t("#{resource.resource_name}.attributes.#{field}")
    name = options.delete(:name)
    if field == :habitats
      habitats_field form_object, name, options
    elsif field == :habitat
      habitat_field form_object, name, options
    elsif field == :substrates
      substrates_field form_object, name, options
    elsif options[:field]
      form_object.association(name, options) + error_span(resource[field])
    elsif options[:method].to_s.include?('localized')
      localized_tabs_field(form_object, field, options)
    else
      form_object.input(name, options) + error_span(resource[field])
    end
  end

  def admin_edit_fields(resource, fields, form_object)
    content_tag(:div, class: 'col-sm-12') do
      if fields.length > 3
        limit = fields.length.odd? ? fields.length/2 + 1 : fields.length/2

        col_1 = ''
        col_2 = ''

        fields[0..limit-1].each { |field| col_1 << admin_edit_field(resource, field[:name], form_object, field) }
        fields[limit..-1].each { |field| col_2 << admin_edit_field(resource, field[:name], form_object, field) }

        content_tag(:div, class: 'col-sm-5') { raw col_1 } + content_tag(:div, class: 'col-sm-6 col-sm-offset-1') { raw col_2 }
      else
        output = ''
        fields.each { |field| output << admin_edit_field(resource, field[:name], form_object, field) }
        content_tag(:div) { raw output }
      end
    end
  end

  def admin_menu(resource, form_object, options={})
    output = ''

    action = form_object.object.new_record? ? :new : :edit

    output << link_to('', :class => "submit-btn btn btn-primary", onclick: "$(this).closest('form').submit()") do
      fo_icon_tag(action.to_sym) + t("#{resource.resource_name}.btn.#{action}.title")
    end

    if [:edit, :show].include?(action)
      path = options[:path] || send("admin_#{resource.resource_name}_path".to_sym, resource)
      output << link_to(path, class: 'btn btn-danger', :method => :delete, :data => { :confirm => t('helpers.links.confirm') }, remote: options[:remote]) do
        fo_icon_tag(:delete) + t("#{resource.resource_name}.btn.delete.title")
      end
    end

    cancel_path = options[:index_path] || (form_object.object.new_record? ? resource.resource_name_index_path : resource.resource_name_path)
    output << link_to(cancel_path, :class => 'btn btn-default', remote: options[:remote]) do
      fo_icon_tag(:cancel) + t('helpers.links.cancel')
    end

    content_tag(:div, class: 'col-sm-12 form-controls') { raw output }
  end

  private

  def resource_title(resource, action)
    if action == :index
      t("shared.sections.#{resource.resource_name}")
    elsif action == :new
      t("#{resource.resource_name}.interface.new")
    else
      resource.resource_title
    end
  end

  def admin_page_header_btn(action, resource, options)
    options[:class] ||= ''
    options[:class] += ' btn btn-circle'
    options[:title] ||= t("#{resource.resource_name}.btn.#{action}.title")

    path = options.delete(:path) || resource.resource_action_path(action)

    link_to(path, options) { fo_icon_tag(action) }
  end
end