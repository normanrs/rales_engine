require 'csv'
def build_merchants
  puts "importing merchants"
  merchants = []
  CSV.foreach('./db/csvs/merchants.csv', OPTIONS) do |merchant|
    merchants << merchant
  end
  merchants.each do |merchant|
    merchant_hash = {id: merchant[:id],
                     name: merchant[:name],
                     created_at: merchant[:created_at],
                     updated_at: merchant[:updated_at]
                    }
    merchant = Merchant.create!(merchant_hash)
  end
  puts "#{Merchant.all.count} merchants imported"
end
