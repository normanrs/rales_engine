class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.best_day(id)
    joins(invoices: [:transactions])
    .where("transactions.result = ?", "success")
    .where("invoice_items.item_id = ?", id)
    .select("items.*, cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold")
    .group("date, items.id")
    .order("sold", "date")
    .last
  end

  def self.by_revenue(max)
    joins(:invoice_items, invoices: [:transactions])
    .where("transactions.result = ?", "success")
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price)")
    .group("items.id").order("sum DESC")
    .limit(max)
  end

end

# joins(invoices: [:transactions])
# .where("transactions.result = ?", "success")
# .where("invoice_items.item_id = ?", id)
# .select("cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold")
# .group("date")
# .order("sold", "date")
# .last
