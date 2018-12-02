Item.joins(invoices: [:transactions])
.where("transactions.result = ?", "success")
.where("invoice_items.item_id = ?", 1099)
.select("cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold")
.group("date")
.order("sold", "date")
.pluck("date")
.last


#
Item.joins(:invoice_items, invoices: [:transactions])
.where("transactions.result = ?", "success")
.select("items.*, sum(invoice_items.quantity * invoice_items.unit_price)")
.group("items.id").order("sum DESC")
.limit(5)

# Relationship Endpoints
# Merchants
# GET /api/v1/merchants/:id/items returns a collection of items associated with that merchant
Merchant.all.first.items

# GET /api/v1/merchants/:id/invoices returns a collection of invoices associated with that merchant from their known orders
Invoice.joins(:transactions).where("result = ?", "success").where(merchant_id: 21)

# Business Intelligence Endpoints
# All Merchants

# GET /api/v1/merchants/most_revenue?quantity=x returns the top x merchants ranked by total revenue
# SQL
# SELECT merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue
# FROM merchants
# join invoices on invoices.merchant_id = merchants.id
# join invoice_items on invoices.id = invoice_items.invoice_id
# join transactions on invoices.id = transactions.invoice_id
# where transactions.result = 'success'
# group by merchants.id
# order by total_revenue desc
# limit 5;
# AR
def self.most_revenue(max)
  joins(invoices: [:transactions, :invoice_items])
  .where("transactions.result = ?", "success")
  .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
  .group("merchants.id")
  .reorder("total_revenue desc")
  .limit(max)
end

# GET /api/v1/merchants/most_items?quantity=x returns the top x merchants ranked by total number of items sold
def self.most_items(max)
  select("merchants.*, SUM(invoice_items.quantity) as total_items")
  .joins(invoices: [:invoice_items, :transactions])
  .where(transactions: {result: "success"}).group(:id)
  .order("total_items desc")
  .limit(max)
end

# GET /api/v1/merchants/revenue?date=x returns the total revenue for date x across all merchants
# Assume the dates provided match the format of a standard ActiveRecord timestamp.

InvoiceItem.joins(invoice: :transactions)
.where("transactions.result = ?", "success")
.where("transactions.created_at > ? AND transactions.created_at < ?", "2012-03-27 00:00:00 UTC", "2012-03-27 24:00:00 UTC")
.sum('invoice_items.unit_price * invoice_items.quantity')

# Single Merchant
# GET /api/v1/merchants/:id/revenue returns the total revenue for that merchant across successful transactions

# GET /api/v1/merchants/:id/revenue?date=x returns the total revenue for that merchant for a specific invoice date x
# GET /api/v1/merchants/:id/favorite_customer returns the customer who has conducted the most total number of successful transactions.
#
# Items
# GET /api/v1/items/most_revenue?quantity=x returns the top x items ranked by total revenue generated
# GET /api/v1/items/most_items?quantity=x returns the top x item instances ranked by total number sold

# GET /api/v1/items/:id/best_day returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.
def self.best_day(id)
  joins(invoices: [:transactions])
  .where("transactions.result = ?", "success")
  .where("invoice_items.item_id = ?", id)
  .select("items.*, cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold")
  .group("date, items.id")
  .order("sold", "date")
  .last
end

# Customers
# GET /api/v1/customers/:id/favorite_merchant returns a merchant where the customer has conducted the most successful transactions
