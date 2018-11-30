class Api::V1::Transactions::InvoiceController < ApplicationController

  def show
    id_in = Transaction.find(params[:id]).invoice_id
    render json: InvoiceSerializer.new(Invoice.find(id_in))
  end

end
