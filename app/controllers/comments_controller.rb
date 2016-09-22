class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    return render_error(:not_found) if current_gram.blank?
    # return render_error(:forbidden) if current_gram.user != current_user

    @comment = current_gram.comments.create(comment_params.merge(user: current_user))
    # redirect_to gram_path(current_gram)

    if @comment.valid?
      flash[:success] = "Comment posted!"
      redirect_to gram_path(current_gram)
    else
      flash[:error] = "Comment could not be posted."
      redirect_to gram_path(current_gram), status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

  def current_gram
    @current_gram ||= Gram.find_by_id(params[:gram_id])
  end

end
