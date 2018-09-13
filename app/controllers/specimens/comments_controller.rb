class Specimens::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Species.where(url: params[:species_url]).first
    # @commentable = Specimen.find(params[:specimen_id])
  end
end
