module StandardResponses
  extend ActiveSupport::Concern

  included do
  end

  def standard_destroy_response(resource, success, options={})
    respond_to do |format|
      if success
        format.html { redirect_to send(resource.resource_name_index_path), notice: "#{resource.resource_name}.notice.destroyed" }
        format.json { head :no_content }
      else
        error_flash = options[:error] || "#{resource.resource_name}.error.destroyed"
        redirection_path = options[:source] == 'index' ? resource.resource_name_index_path : resource.resource_name_path
        format.html { redirect_to redirection_path, flash: { error: error_flash } }
        format.json { render json: @species.errors, status: :unprocessable_entity }
      end
    end
  end

  def standard_create_response(resource, success, options={})
    respond_to do |format|
      if success
        format.html { redirect_to resource.resource_name_path, notice: 'species.notice.created' }
        format.json { render :show, status: :created, location: resource }
      else
        format.html { render :new }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def standard_nil_record_response(klass)
    resource = klass.new
    respond_to do |format|
      format.html { redirect_to send(resource.resource_name_index_path), flash: { error: "#{resource.resource_name}.error.not_found" } }
      format.json { head :no_content }
    end
  end
end