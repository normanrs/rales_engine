class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :invoice_id, :credt_card_number, :credit_card_expiration_date, :result
end
