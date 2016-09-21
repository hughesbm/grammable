class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

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
    return render_not_found if current_gram.blank?
  end

  def edit
    return render_not_found if current_gram.blank?
  end

  def update
    return render_not_found if current_gram.blank?
    current_gram.update_attributes(gram_params)
    if current_gram.valid?
      flash[:success] = "Gram edited!"
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return render_not_found if current_gram.blank?
    current_gram.destroy
    flash[:success] = "Gram deleted."
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:message)
  end

  helper_method :current_gram

  def current_gram
    @current_gram ||= Gram.find_by_id(params[:id])
  end

  def render_not_found
    render plain: 'Gram not found! :(', status: :not_found
  end

end
