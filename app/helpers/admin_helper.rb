module AdminHelper

  def admin_page_header(resource, action, options={})
    output = ''

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
          fo_icon_tag(resource.resource_name.to_sym) + resource_title(resource, action)
        end
    end
  end

  def admin_show_field(resource, field)
    value = resource.send(field)

    content_tag(:dt) do
      content_tag(:strong) do
        t("#{resource.resource_name}.attributes.#{field}") + ':'
      end
    end +
      content_tag(:dd) do
        if value.blank?
          '-'
        else
          value.respond_to?(:resource_title) ? value.resource_title : value
        end
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
    options[:label] = t("#{resource.resource_name}.attributes.#{field}")
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

    action = form_object.object.new_record? ? :new : :edit

    output << link_to('#', :class => "btn btn-primary", onclick: "$(this).closest('form').submit()") do
      fo_icon_tag(action.to_sym) + t("#{resource.resource_name}.btn.#{action}.title")
    end

    output << link_to(send("admin_#{resource.resource_name}_path".to_sym, resource), class: 'btn btn-danger', :method => :delete, :data => { :confirm => t('helpers.links.confirm') }) do
      fo_icon_tag(:delete) + t("#{resource.resource_name}.btn.delete.title")
    end if [:edit, :show].include?(action)

    cancel_path = form_object.object.new_record? ? resource.resource_name_index_path : resource.resource_name_path
    output << link_to(cancel_path, :class => 'btn btn-default') do
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