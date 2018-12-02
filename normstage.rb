Item.joins(invoices: [:transactions])
.where("transactions.result = ?", "success")
.where("invoice_items.item_id = ?", 1099)
.select("cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold")
.group("date")
.order("sold", "date")
.pluck("date")
.last


Item.joins(invoices: [:transactions]).where("transactions.result = ?", "success").where("invoice_items.item_id = ?", 1099).select("cast(invoices.created_at AS date) AS date, sum(invoice_items.quantity) AS sold").group("date").order("sold", "date").last.date
