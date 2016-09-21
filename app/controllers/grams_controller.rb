class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)
    if @gram.valid?
      flash[:success] = "Gram posted!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    return render_error(:not_found) if current_gram.blank?
  end

  def edit
    return render_error(:not_found) if current_gram.blank?
    return render_error(:forbidden) if current_gram.user != current_user
  end

  def update
    return render_error(:not_found) if current_gram.blank?
    return render_error(:forbidden) if current_gram.user != current_user
    current_gram.update_attributes(gram_params)
    if current_gram.valid?
      flash[:success] = "Gram edited!"
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return render_error(:not_found) if current_gram.blank?
    return render_error(:forbidden) if current_gram.user != current_user
    current_gram.destroy
    flash[:success] = "Gram deleted."
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:message, :picture)
  end

  helper_method :current_gram

  def current_gram
    @current_gram ||= Gram.find_by_id(params[:id])
  end

  def render_error(status)
    render plain: "#{status.to_s.titleize}. :(", status: status
  end

end
