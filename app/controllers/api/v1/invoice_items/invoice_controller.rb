class Api::V1::InvoiceItems::InvoiceController < ApplicationController

  def show
    id_in =   id_in = InvoiceItem.find(params[:id]).invoice_id
    render json: InvoiceSerializer.new(Invoice.find(id_in))
  end

end
