FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Stuff World Merchant#{n}" }
  end
end
