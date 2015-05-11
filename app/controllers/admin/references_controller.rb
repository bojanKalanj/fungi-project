class Admin::ReferencesController < Admin::AdminController

  before_action :set_reference
  before_action :set_reference_fields

  authorize_resource

  def destroy
    if @reference.characteristics.count > 0
      standard_destroy_response(@reference, false, error: 'reference.error.destroyed_has_characteristics', source: params['source'])
    else
      standard_destroy_response(@reference, @reference.destroy, source: params['source'])
    end
  end

  private
  def set_reference
    if action == :new
      @reference = Reference.new
    elsif action == :create
      @reference = Reference.new(resource_params)
    elsif action == :index
          @references = Reference.all
    else
      @reference = Reference.friendly.find(params[:id])
    end
  end

  def set_reference_fields
    if action == :index
      @fields = [
        { name: :title },
        { name: :authors },
        { name: :isbn },
        { name: :url, method: :wrap_in_link, options: { external: true } },
        { name: :actions, no_label: true }
      ]
    else
      @fields = [
        { name: :title },
        { name: :authors },
        { name: :isbn },
        { name: :url }
      ]
    end
  end

  def resource_params
    params.require(:reference).permit(Reference::PUBLIC_FIELDS)
  end

  def current_resource
    @reference
  end
end
