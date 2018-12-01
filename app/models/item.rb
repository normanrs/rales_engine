class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.best_day(id)
    joins(invoices: [:transactions])
    .where("transactions.result = ?", "success")
    .where("invoice_items.item_id = ?", id)
    .select("cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold")
    .group("date")
    .order("sold", "date")
    .last.date
  end

end
