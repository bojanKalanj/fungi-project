class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    if @commentable.class == Specimen
      if @comment.save
        redirect_to specimen_path(@commentable.id), notice: "Komentar je poslat"
      else
        redirect_to specimen_path(@commentable.id)
        flash[:danger] = "Komentar nije poslat"
      end
    else
      if @comment.save
        redirect_to @commentable, notice: "Komentar je poslat"
      else
        redirect_to @commentable
        flash[:danger] = "Komentar nije poslat"
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.delete
    if @commentable.class == Specimen
      redirect_to specimen_path(@commentable.id), notice: "Komentar je obrisan"
    else
      redirect_to @commentable, notice: "Komentar je obrisan"
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end
