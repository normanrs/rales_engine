class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: Merchant.find_by(search_params)
    else
      render json: Merchant.random
    end
  end

  def index
    render json: Merchant.where(search_params)
  end

private

  def search_params
    params.permit(:name, :created_at, :updated_at, :id)
  end

end
