class Api::V1::Merchants::MostRevenueController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.most_revenue(search_params))
  end

private

  def search_params
    params.require(:quantity)
  end

end
