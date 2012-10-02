class ReportsController < ApplicationController
  
  def index
    @customer = Customer.find(params[:customer_id])
  end

  def create
    @customer = Customer.find(params[:customer_id])
    redirect_to summary_customer_tasks_path(:start => params[:start_date], :end => params[:end_date])
  end

end
