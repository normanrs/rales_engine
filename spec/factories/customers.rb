FactoryBot.define do
  factory :customer do
    sequence(:first_name) { |n| "Terry#{n}" }
    sequence(:last_name) { |n| "Frankenstein#{n}" }
  end
end
