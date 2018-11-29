FactoryBot.define do
  factory :transaction do
    credit_card_number { 1 }
    credit_card_expiration_date { "2018-11-28" }
    result { "MyString" }
    invoice { nil }
  end
end
