class Api::V1::Items::MerchantController < ApplicationController

  def show
    id_in = Item.find(params[:id]).merchant_id
    render json: MerchantSerializer.new(Merchant.find(id_in))
  end

end
