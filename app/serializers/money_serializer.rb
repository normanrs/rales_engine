class MoneySerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :money
end
