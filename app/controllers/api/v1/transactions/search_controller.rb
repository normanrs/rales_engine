class Api::V1::Transactions::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: TransactionSerializer.new(Transaction.find_by(search_params))
    else
      render json: TransactionSerializer.new(Transaction.random)
    end
  end

  def index
    render json: TransactionSerializer.new(Transaction.where(search_params))
  end

private

  def search_params
    params.permit(:invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at, :id)
  end

end
