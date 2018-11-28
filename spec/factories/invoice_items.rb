FactoryBot.define do
  factory :invoice_item do
    qty { 1 }
    unit_price { 1 }
    item { nil }
    invoice { nil }
  end
end
