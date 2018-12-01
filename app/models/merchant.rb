class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  def most_revenue(max)
    joins(invoices: [:transactions, :invoice_items])
    .where("transactions.result = ?", "success")
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    .group("merchants.id")
    .reorder("total_revenue desc")
    .limit(max)

  end

end
