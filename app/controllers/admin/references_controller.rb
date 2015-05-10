class Admin::ReferencesController < ApplicationController
  include StandardResponses

  before_action :set_reference, only: [:show, :edit, :update, :destroy]
  before_action :set_reference_fields
  before_action :authenticate_user!

  def index
    @references = Reference.all

    @reference_fields = [
      { name: :title },
      { name: :authors },
      { name: :isbn },
      { name: :url, method: :wrap_in_link, options: { external: true } },
      { name: :actions, no_label: true }
    ]
  end

  def show
    standard_nil_record_response(Reference) if @reference.nil?
  end

  def new
    @reference = Reference.new
  end

  def edit
    standard_nil_record_response(Reference) if @reference.nil?
  end

  def create
    @reference = Reference.new(reference_params)
    standard_create_response @reference, @reference.save, fields: @reference_fields
  end

  def update
    standard_update_response @reference, @reference.update(reference_params), fields: @reference_fields
  end

  def destroy
    if @reference.characteristics.count > 0
      standard_destroy_response(@reference, false, error: 'reference.error.destroyed_has_characteristics', source: params['source'])
    else
      standard_destroy_response(@reference, @reference.destroy, source: params['source'])
    end
  end

  private
  def set_reference
    @reference = Reference.friendly.find(params[:id])
  rescue
    @reference = nil
  end

  def set_reference_fields
    @reference_fields = [
      { name: :title },
      { name: :authors },
      { name: :isbn },
      { name: :url }
    ]
  end

  def reference_params
    params.require(:reference).permit(Reference::PUBLIC_FIELDS)
  end
end
