class Api::V1::Invoices::CustomerController < ApplicationController

  def show
    id_in = Invoice.find(params[:id]).customer_id
    render json: CustomerSerializer.new(Customer.find(id_in))
  end

end
