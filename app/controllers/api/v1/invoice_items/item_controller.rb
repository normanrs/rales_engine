class Api::V1::InvoiceItems::ItemController < ApplicationController

  def show
    id_in = InvoiceItem.find(params[:id]).item_id
    render json: ItemSerializer.new(Item.find(id_in))
  end

end
