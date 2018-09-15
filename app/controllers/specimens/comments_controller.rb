class Specimens::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Specimen.friendly.find(params[:specimen_id])
  end
end
