require 'csv'
OPTIONS = {headers: true, header_converters: :symbol}

task create_merchants: :environment do
  counter = 0
  CSV.foreach('./db/csvs/merchants.csv', OPTIONS) do |row|
    attempt = Merchant.create!(row.to_hash)
    counter += 1 if attempt.persisted?
  end
  puts "#{counter} merchants imported"
end

task create_customers: :environment do
  counter = 0
  CSV.foreach('./db/csvs/customers.csv', OPTIONS) do |row|
    attempt = Customer.create!(row.to_hash)
    counter += 1 if attempt.persisted?
  end
  puts "#{counter} customers imported"
end

task create_items: :environment do
  counter = 0
  CSV.foreach('./db/csvs/items.csv', OPTIONS) do |row|
    attempt = Item.create!(row.to_hash)
    counter += 1 if attempt.persisted?
  end
  puts "#{counter} items imported"
end

task create_invoices: :environment do
  counter = 0
  CSV.foreach('./db/csvs/invoices.csv', OPTIONS) do |row|
    attempt = Invoice.create!(row.to_hash)
    counter += 1 if attempt.persisted?
  end
  puts "#{counter} invoices imported"
end

task create_transactions: :environment do
  counter = 0
  CSV.foreach('./db/csvs/transactions.csv', OPTIONS) do |row|
    attempt = Transaction.create!(row.to_hash)
    counter += 1 if attempt.persisted?
  end
  puts "#{counter} transactions imported"
end

task create_invoice_items: :environment do
  counter = 0
  CSV.foreach('./db/csvs/invoice_items.csv', OPTIONS) do |row|
    attempt = InvoiceItem.create!(row.to_hash)
    counter += 1 if attempt.persisted?
  end
  puts "#{counter} invoice_items imported"
end

task :import do
  Rake::Task["create_merchants"].invoke
  Rake::Task["create_customers"].invoke
  # Rake::Task["create_items"].invoke
  # Rake::Task["create_invoices"].invoke
  # Rake::Task["create_transactions"].invoke
  # Rake::Task["create_invoice_items"].invoke
end
