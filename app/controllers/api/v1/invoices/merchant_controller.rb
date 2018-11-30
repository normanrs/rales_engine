class Api::V1::Invoices::MerchantController < ApplicationController

  def show
    id_in =   id_in = Invoice.find(params[:id]).merchant_id
    render json: MerchantSerializer.new(Merchant.find(id_in))
  end

end
