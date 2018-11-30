FactoryBot.define do
  factory :invoice_item do
    quantity { rand(1...100) }
    unit_price { rand(1...1000)}
    association :item, factory: :item
    association :invoice, factory: :invoice
  end
end
