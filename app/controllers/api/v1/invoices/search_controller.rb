class Api::V1::Invoices::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: Invoice.find_by(search_params)
    else
      render json: Invoice.random
    end
  end

  def index
    render json: Invoice.where(search_params)
  end

private

  def search_params
    params.permit(:status, :created_at, :updated_at, :id)
  end

end
