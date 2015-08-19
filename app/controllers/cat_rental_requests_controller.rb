class CatRentalRequestsController < ApplicationController
  before_action :confirm_owner
  skip_before_action :confirm_owner, only: [:show, :new, :create]

  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    redirect_to cat_url(@request.cat_id)
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!
    redirect_to cat_url(@request.cat_id)
  end

  def create
    @request = current_user.requests.new(rental_params)
    @request.user_id = current_user.id
    @cats = Cat.all
    if @request.save
      redirect_to cat_url(@request.cat_id)
    else
      render :new
    end
  end

  private
  def rental_params
    params.require(:request).permit(:cat_id, :start_date, :end_date)
  end

  def confirm_owner
    redirect_to cats_url if current_user != CatRentalRequest.find(params[:id]).cat.owner
  end
end
