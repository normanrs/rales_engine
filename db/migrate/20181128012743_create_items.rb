class CreateItems < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
    create_table :items do |t|
      t.references :merchant, foreign_key: true
      t.citext :name
      t.string :description
      t.bigint :unit_price

      t.timestamps
    end
  end
end
