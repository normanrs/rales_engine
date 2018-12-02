class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  def self.revenue(date)
    date_start = DateTime.parse(date + " " + "00:00:00 UTC")
    date_end = DateTime.parse(date + " " + "24:00:00 UTC")
    InvoiceItem.joins(invoice: :transactions)
    .where("transactions.result = ?", "success")
    .where("transactions.created_at > ? AND transactions.created_at < ?", "2018-08-01 00:00:00 UTC", "2018-08-01 24:00:00 UTC")
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def self.most_revenue(max)
    joins(invoices: [:transactions, :invoice_items])
    .where("transactions.result = ?", "success")
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    .group("merchants.id")
    .reorder("total_revenue desc")
    .limit(max)
  end

  def self.most_items(max)
    select("merchants.*, SUM(invoice_items.quantity) as total_items")
    .joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: "success"}).group(:id)
    .order("total_items desc")
    .limit(max)
  end

end
