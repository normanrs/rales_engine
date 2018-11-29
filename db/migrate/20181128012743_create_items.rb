class CreateItems < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
    create_table :items do |t|
      t.citext :name
      t.string :description
      t.integer :unit_price
      t.integer :merchant_id

      t.timestamps
    end
  end
end
