FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item#{n}" }
    sequence(:description) { |n| "This is a thing#{n}" }
    unit_price {rand(1...1000)}
    association :merchant, factory: :merchant
  end
end
