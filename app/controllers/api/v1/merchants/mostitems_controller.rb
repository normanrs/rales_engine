class Api::V1::Merchants::MostitemsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.most_items(params[:quantity]))
  end

private

  def search_params
    params.require(:quantity)
  end

end
