FactoryBot.define do
  factory :transaction do
    association :invoice, factory: :invoice
    credit_card_number { 1111222233334440 + rand(1...9) }
    credit_card_expiration_date { "2018-11-28" }
    result { ["success", "failed"].sample }
  end
end
