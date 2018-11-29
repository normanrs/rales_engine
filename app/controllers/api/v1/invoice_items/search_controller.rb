class Api::V1::InvoiceItems::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: InvoiceItemSerializer.new(InvoiceItem.find_by(search_params))
    else
      render json: InvoiceItemSerializer.new(InvoiceItem.random)
    end
  end

  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.where(search_params))
  end

private

  def search_params
    params.permit(:quantity, :unit_price, :created_at, :updated_at, :id)
  end

end
