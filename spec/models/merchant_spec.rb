require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  it ".most_revenue" do
    merchant1 = create(:merchant, name: 'Andy')
    merchant2 = create(:merchant, name: 'Bob')
    merchant3 = create(:merchant, name: 'Charles')
    merchant4 = create(:merchant, name: 'Dave')
    invoice1 = create(:invoice, merchant: merchant1)
    invoice2 = create(:invoice, merchant: merchant2)
    invoice3 = create(:invoice, merchant: merchant3)
    invoice4 = create(:invoice, merchant: merchant4)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)
    item3 = create(:item, merchant: merchant3)
    item4 = create(:item, merchant: merchant4)
    invoice_item1 = create(:invoice_item, quantity: 1, unit_price: 100, invoice: invoice1, item: item1)
    invoice_item2 = create(:invoice_item, quantity: 1, unit_price: 200, invoice: invoice2, item: item2)
    invoice_item3 = create(:invoice_item, quantity: 10, unit_price: 300, invoice: invoice3, item: item3)
    invoice_item4 = create(:invoice_item, quantity: 20, unit_price: 400, invoice: invoice4, item: item4)
    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')
    transaction4 = create(:transaction, invoice: invoice4, result: 'success')

    expect(Merchant.most_revenue(2)).to eq([merchant4, merchant3])
    expect(Merchant.most_revenue(1)).to eq([merchant4])
  end

  it ".most_items" do
    merchant1 = create(:merchant, name: 'Andy')
    merchant2 = create(:merchant, name: 'Bob')
    merchant3 = create(:merchant, name: 'Charles')
    merchant4 = create(:merchant, name: 'Dave')
    invoice1 = create(:invoice, merchant: merchant1)
    invoice2 = create(:invoice, merchant: merchant2)
    invoice3 = create(:invoice, merchant: merchant3)
    invoice4 = create(:invoice, merchant: merchant4)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)
    item3 = create(:item, merchant: merchant3)
    item4 = create(:item, merchant: merchant4)
    invoice_item1 = create(:invoice_item, quantity: 1, unit_price: 100, invoice: invoice1, item: item1)
    invoice_item2 = create(:invoice_item, quantity: 5, unit_price: 200, invoice: invoice2, item: item2)
    invoice_item3 = create(:invoice_item, quantity: 10, unit_price: 300, invoice: invoice3, item: item3)
    invoice_item4 = create(:invoice_item, quantity: 20, unit_price: 400, invoice: invoice4, item: item4)
    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')
    transaction4 = create(:transaction, invoice: invoice4, result: 'success')

    expect(Merchant.most_items(2)).to eq([merchant4, merchant3])
    expect(Merchant.most_items(1)).to eq([merchant4])
  end



end
