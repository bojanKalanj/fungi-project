class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    @comment.save
    if @commentable.class == Specimen
      redirect_to specimen_path(@commentable.id), notice: "Komentar je poslat"
    else
      redirect_to @commentable, notice: "Komentar je poslat"
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end
