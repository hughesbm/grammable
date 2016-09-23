class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    return render_error(:not_found) if current_gram.blank?

    @comment = current_gram.comments.create(comment_params.merge(user: current_user))

    if @comment.valid?
      redirect_to gram_path(current_gram)
    else
      flash[:error] = "Comment could not be posted."
      redirect_to gram_path(current_gram), status: :unprocessable_entity
    end
  end

  def destroy
    return render_error(:not_found) if current_comment.blank?
    return render_error(:forbidden) unless current_user && (current_user == current_comment.user || current_user == current_comment.gram.user)
    gram = current_comment.gram
    current_comment.destroy
    redirect_to gram_path(gram)
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

  def current_gram
    @current_gram ||= Gram.find_by_id(params[:gram_id])
  end

  def current_comment
    @current_comment ||= Comment.find_by_id(params[:id])
  end

end
