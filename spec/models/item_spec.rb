require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  it '.best_day' do
    merchant1 = create(:merchant, name: 'Andy')
    merchant2 = create(:merchant, name: 'Bob')
    merchant3 = create(:merchant, name: 'Charles')
    merchant4 = create(:merchant, name: 'Dave')
    invoice1 = create(:invoice, merchant: merchant1, created_at: "2018-08-01 09:00:00 UTC")
    invoice2 = create(:invoice, merchant: merchant2, created_at: "2018-08-02 09:00:00 UTC")
    invoice3 = create(:invoice, merchant: merchant3, created_at: "2018-08-03 09:00:00 UTC")
    invoice4 = create(:invoice, merchant: merchant4, created_at: "2018-08-04 09:00:00 UTC")
    item1 = create(:item, merchant: merchant1)
    invoice_item1 = create(:invoice_item, quantity: 1, unit_price: 100, invoice: invoice1, item: item1)
    invoice_item2 = create(:invoice_item, quantity: 5, unit_price: 100, invoice: invoice2, item: item1)
    invoice_item3 = create(:invoice_item, quantity: 20, unit_price: 100, invoice: invoice3, item: item1)
    invoice_item4 = create(:invoice_item, quantity: 20, unit_price: 100, invoice: invoice4, item: item1)
    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')
    transaction4 = create(:transaction, invoice: invoice4, result: 'success')

    actual = Item.best_day(item1.id)
    expect(actual.date).to eq(invoice4.created_at.to_date)

  end

end
