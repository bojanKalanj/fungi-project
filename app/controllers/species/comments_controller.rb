class Species::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    # @commentable = Species.friendly.find(params[:specimen_id])
    @commentable = Species.where(url: params[:species_url]).first
  end
end
