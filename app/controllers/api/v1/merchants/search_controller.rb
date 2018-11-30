class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: MerchantSerializer.new(Merchant.find_by(search_params))
    else
      render json: MerchantSerializer.new(Merchant.random)
    end
  end

  def index
    render json: MerchantSerializer.new(Merchant.where(search_params))
  end

private

  def search_params
    params.permit(:name, :created_at, :updated_at, :id)
  end

end
