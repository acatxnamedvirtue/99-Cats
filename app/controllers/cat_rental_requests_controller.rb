class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
  end

  def approve
    @request = CatRentalRequest.find(params[:cat_rental_request_id])
    @request.approve!
    redirect_to cat_url(@request.cat_id)
  end

  def deny
    @request = CatRentalRequest.find(params[:cat_rental_request_id])
    @request.deny!
    redirect_to cat_url(@request.cat_id)
  end

  def create
    @request = CatRentalRequest.new(rental_params)
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
end
