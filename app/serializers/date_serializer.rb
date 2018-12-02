class DateSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :date
end
