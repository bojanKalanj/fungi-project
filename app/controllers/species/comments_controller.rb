class Species::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Species.where(url: params[:species_url]).first
    # @commentable = Species.where(url: params[:url]).first

  end
end
