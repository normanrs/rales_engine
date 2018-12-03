class MerchantsumSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :created_at, :updated_at, :revenue
end
