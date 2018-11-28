class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
    create_table :invoices do |t|
      t.integer :customer_id
      t.integer :merchant_id
      t.citext :status

      t.timestamps
    end
  end
end