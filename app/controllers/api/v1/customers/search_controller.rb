class Api::V1::Customers::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: CustomerSerializer.new(Customer.find_by(search_params))
    else
      render json: CustomerSerializer.new(Customer.random)
    end
  end

  def index
    render json: CustomerSerializer.new(Customer.where(search_params))
  end

private

  def search_params
    params.permit(:first_name, :last_name, :created_at, :updated_at, :id)
  end

end
