class CatsController < ApplicationController
  before_action :confirm_owner, only: [:edit, :update]

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
    @owner = User.find(@cat.user_id)
    @requests = @cat.rental_requests.includes(:requester).order(:start_date)
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end
  
  private
  def cat_params
    params.require(:cat).permit(:birthdate, :name, :color, :sex, :description)
  end

  def confirm_owner
    redirect_to cats_url if current_user != Cat.find(params[:id]).owner
  end

end
