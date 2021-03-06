class Api::V1::Invoices::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: InvoiceSerializer.new(Invoice.find_by(search_params))
    else
      render json: InvoiceSerializer.new(Invoice.random)
    end
  end

  def index
    render json: InvoiceSerializer.new(Invoice.where(search_params))
  end

private

  def search_params
    params.permit(:customer_id, :merchant_id, :status, :created_at, :updated_at, :id)
  end

end
