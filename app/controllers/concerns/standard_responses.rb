module StandardResponses
  extend ActiveSupport::Concern

  included do
  end

  def standard_destroy_response(resource, success, options={})
    respond_to do |format|
      if success
        format.html { redirect_to resource.resource_name_index_path, notice: "#{resource.resource_name}.notice.destroyed" }
        format.json { head :no_content }
      else
        # puts resource.errors.inspect if Rails.env.development?

        error_flash = options[:error] || "#{resource.resource_name}.error.destroyed"
        redirection_path = options[:source] == 'index' ? resource.resource_name_index_path : resource.resource_name_path
        format.html { redirect_to redirection_path, flash: { error: error_flash } }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def standard_create_response(resource, success, options={})
    respond_to do |format|
      if success
        format.html { redirect_to resource.resource_name_path, notice: "#{resource.resource_name}.notice.created" }
        format.json { render :show, status: :created, location: resource }
      else
         # puts resource.errors.inspect unless Rails.env.production?

        flash_uncaught_messages(resource, resource.errors, options)

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def standard_update_response(resource, success, options={})
    respond_to do |format|
      if success
        format.html { redirect_to resource.resource_name_path, notice: "#{resource.resource_name}.notice.updated" }
        format.json { render :show, status: :created, location: resource }
      else
        # puts resource.errors.inspect unless Rails.env.production?

        flash_uncaught_messages(resource, resource.errors, options)

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def standard_nil_record_response(klass)
    resource = klass.new
    respond_to do |format|
      format.html { redirect_to resource.resource_name_index_path, flash: { error: "#{resource.resource_name}.error.not_found" } }
      format.json { head :no_content }
    end
  end

  private

  def field_names(fields)
    fields.map { |f| f[:name] }
  end

  def flash_uncaught_messages(resource, error_messages, options={})
    return unless options[:fields]

    flash[:error] = []
    (error_messages.keys - field_names(options[:fields])).each do |field|
      error_messages[field].each do |msg|
        flash[:error] << I18n.translate("#{resource.resource_name}.attributes.#{field}") + ' - ' + msg
      end
    end
  end
end