Item.joins(invoices: [:transactions])
.where("transactions.result = ?", "success")
.where("invoice_items.item_id = ?", 1099)
.select("cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold")
.group("date")
.order("sold", "date")
.pluck("date")
.last

Item.joins(:invoice_items, invoices: [:transactions])
.where("transactions.result = ?", "success")
.select("items.*, sum(invoice_items.quantity * invoice_items.unit_price)")
.group("items.id").order("sum DESC")
.limit(5)
