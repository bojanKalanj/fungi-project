module AdminHelper

  def admin_page_header(resource, action, options={})
    output = ''
    resource_name = resource_name(resource)

    if current_user && current_user.supervisor?
      resource_name_index_path = resource_name[-1] == 's' ? resource_name + '_index' : resource_name

      output << link_to(send("admin_#{resource_name_index_path}_path".to_sym), class: 'btn btn-default btn-circle', title: t("helpers.links.cancel")) do
        fo_icon_tag(:cancel)
      end if [:new, :edit, :show].include?(action)

      output << link_to(send("new_admin_#{resource_name}_path".to_sym), class: 'btn btn-primary btn-circle', title: t("#{resource_name}.btn.new.title")) do
        fo_icon_tag(:new)
      end if action == :index

      output << link_to(send("edit_admin_#{resource_name}_path".to_sym, resource), class: 'btn btn-primary btn-circle', title: t("#{resource_name}.btn.edit.title")) do
        fo_icon_tag(:edit)
      end if action == :show

      output << link_to(send("admin_#{resource_name}_path".to_sym, resource), class: 'btn btn-default btn-circle', title: t("#{resource_name}.btn.show.title")) do
        fo_icon_tag(:show)
      end if action == :edit

      output << link_to(send("admin_#{resource_name}_path".to_sym, resource), class: 'btn btn-danger btn-circle', title: t("#{resource_name}.btn.destroy.title"), :method => :delete, :data => { :confirm => t('helpers.links.confirm') }) do
        fo_icon_tag(:delete)
      end if [:edit, :show].include?(action)
    end

    if action == :index
      title = t("shared.sections.#{resource_name}")
    elsif action == :new
      title = t("#{resource_name}.interface.new")
    else
      title = resource.resource_title
    end

    title_class = nil
    title_class = options[:title][:class] if options[:title]

    content_tag(:div, class: 'page-header') do
      raw(output)+
        content_tag(:h1, class: title_class) do
          fo_icon_tag(resource_name.to_sym) + title
        end
    end
  end

  def resource_name(resource)
    resource.is_a?(Symbol) ? resource.to_s : resource.resource_name
  end

  def admin_show_field(resource, field)
    value = resource.send(field)
    resource_name = resource_name(resource)
    content_tag(:dt) do
      content_tag(:strong) do
        t("#{resource_name}.attributes.#{field}") + ':'
      end
    end +
      content_tag(:dd) do
        value.blank? ? '-' : value
      end
  end

  def admin_show_fields(resource, fields)
    output = ''
    fields.each { |field| output << admin_show_field(resource, field) }

    content_tag(:dl, class: 'dl-horizontal') do
      raw output
    end
  end

  def admin_edit_field(resource, field, form_object, options={})
    resource_name = resource_name(resource)
    options[:label] = t("#{resource_name}.attributes.#{field}")
    name = options.delete(:name)
    form_object.input(name, options) + error_span(resource[field])
  end

  def admin_edit_fields(resource, fields, form_object)
    content_tag(:div, class: 'col-sm-12') do
      if fields.length > 9
        limit = fields.length.odd? ? fields.length/2 + 1 : fields.length

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

  def admin_menu(resource, form_object, args={})
    output = ''

    resource_name = resource_name(resource)
    resource_name_index_path = resource_name[-1] == 's' ? resource_name + '_index' : resource_name

    action = form_object.object.new_record? ? :new : :edit

    output << link_to('#', :class => "btn btn-primary", onclick: "$(this).closest('form').submit()") do
      fo_icon_tag(action.to_sym) +  t("#{resource_name}.btn.#{action}.title")
    end

    output << link_to(send("admin_#{resource_name}_path".to_sym, resource), class: 'btn btn-danger', :method => :delete, :data => { :confirm => t('helpers.links.confirm') }) do
      fo_icon_tag(:delete) +  t("#{resource_name}.btn.destroy.title")
    end if [:edit, :show].include?(action)

    cancel_path = form_object.object.new_record? ? resource_name_index_path : resource_name
    output << link_to(send("admin_#{cancel_path}_path".to_sym, resource), :class => 'btn btn-default') do
      fo_icon_tag(:cancel) + t("helpers.links.cancel")
    end

    content_tag(:div, class: 'col-sm-12 form-controls') { raw output }
  end

end