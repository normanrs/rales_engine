require 'rails_helper'

describe 'items API' do

  before(:each) do
    @customer = create(:customer)
    @merchant = create(:merchant)
  end

  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful
    result = JSON.parse(response.body)
    expect(result["data"].count).to eq(3)
  end

  it "sends one item by id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(id)
  end

  it "sends one item at random" do
    create_list(:item, 3)

    get "/api/v1/items/random"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result.class).to eq(Hash)
  end

  it "finds one item by case_insensitive name" do
    test1 = create(:item, name: "Norm")
    test2 = create(:item, name: "Dave")
    get "/api/v1/items/find?name=#{test2.name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(test2.id)
  end

  it "finds one item by id" do
    test1 = create(:item)
    test2 = create(:item)
    get "/api/v1/items/find?id=#{test2.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(test2.id)
  end

  it "finds one item by created_at" do
    item = create(:item, merchant_id:@merchant.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/items/find?created_at=#{item.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(item.id)
  end

  it "finds one item by updated_at" do
    item = create(:item, merchant_id:@merchant.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/items/find?created_at=#{item.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(item.id)
  end

  it "finds all items by case_insensitive name" do
    test1 = create(:item, name: "Norm")
    test2 = create(:item, name: "Norm")
    get "/api/v1/items/find_all?name=#{test2.name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all items by created_at" do
    item1 = create(:item, merchant_id:@merchant.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    item2 = create(:item, merchant_id:@merchant.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    item3 = create(:item, merchant_id:@merchant.id, created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/items/find_all?created_at=#{item1.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all items by updated_at" do
    item1 = create(:item, merchant_id:@merchant.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    item2 = create(:item, merchant_id:@merchant.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    item3 = create(:item, merchant_id:@merchant.id, created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/items/find_all?created_at=#{item1.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all items by id" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    get "/api/v1/items/find_all?id=#{item1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one item by unit price" do
    test1 = create(:item, unit_price: 40)
    test2 = create(:item, unit_price: 80)
    get "/api/v1/items/find?unit_price=#{test2.unit_price}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(test2.id)
  end

  it "finds all items by unit price" do
    test1 = create(:item, unit_price: 40)
    test2 = create(:item, unit_price: 40)
    get "/api/v1/items/find_all?unit_price=#{test2.unit_price}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds one item by merchant id" do
    test1 = create(:item)
    test2 = create(:item)
    get "/api/v1/items/find?merchant_id=#{test2.merchant_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(test2.id)
  end

  it "finds all items by merchant id" do
    test1 = create(:item)
    test2 = create(:item)
    get "/api/v1/items/find_all?merchant_id=#{test2.merchant_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "returns invoice_items associated with an item" do
    item1 = create(:item)
    invoice_items1 = create_list(:invoice_item, 10, item_id: item1.id)
    ids = invoice_items1.map { |i| i.id }
    create_list(:invoice_item, 5)

    get "/api/v1/items/#{item1.id}/invoice_items"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(10)
    expect(ids).to include(result["data"].first["attributes"]["id"])
  end

  it "returns merchant associated with an item" do
    item1 = create(:item)

    get "/api/v1/items/#{item1.id}/merchant"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["attributes"]["id"]).to eq(item1.merchant_id)
  end

  it "returns best day for one item" do
    merchant1 = create(:merchant, name: 'Andy')
    # merchant2 = create(:merchant, name: 'Bob')
    # merchant3 = create(:merchant, name: 'Charles')
    # merchant4 = create(:merchant, name: 'Dave')
    item1 = create(:item, merchant: merchant1)
    invoice1 = create(:invoice, merchant: merchant1, created_at: "2018-08-01 09:00:00 UTC")
    invoice2 = create(:invoice, merchant: merchant1, created_at: "2018-08-02 09:00:00 UTC")
    invoice3 = create(:invoice, merchant: merchant1, created_at: "2018-08-03 09:00:00 UTC")
    invoice4 = create(:invoice, merchant: merchant1, created_at: "2018-08-04 09:00:00 UTC")
    invoice5 = create(:invoice, merchant: merchant1, created_at: "2018-08-05 09:00:00 UTC")
    invoice_item1 = create(:invoice_item, quantity: 1, unit_price: 100, invoice: invoice1, item: item1)
    invoice_item2 = create(:invoice_item, quantity: 5, unit_price: 100, invoice: invoice2, item: item1)
    invoice_item3 = create(:invoice_item, quantity: 20, unit_price: 100, invoice: invoice3, item: item1)
    invoice_item4 = create(:invoice_item, quantity: 20, unit_price: 100, invoice: invoice4, item: item1)
    invoice_item5 = create(:invoice_item, quantity: 100, unit_price: 100, invoice: invoice5, item: item1)
    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')
    transaction4 = create(:transaction, invoice: invoice4, result: 'success')
    transaction5 = create(:transaction, invoice: invoice4, result: 'failed')

    get "/api/v1/items/#{item1.id}/best_day"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["attributes"]["id"]).to eq(item1.id)
  end

  it "returns top x items by total revenue" do
    merchant1 = create(:merchant, name: 'Andy')
    merchant2 = create(:merchant, name: 'Bob')
    merchant3 = create(:merchant, name: 'Charles')
    merchant4 = create(:merchant, name: 'Dave')
    invoice1 = create(:invoice, merchant: merchant1, created_at: "2018-08-01 09:00:00 UTC")
    invoice2 = create(:invoice, merchant: merchant2, created_at: "2018-08-02 09:00:00 UTC")
    invoice3 = create(:invoice, merchant: merchant1, created_at: "2018-08-03 09:00:00 UTC")
    invoice4 = create(:invoice, merchant: merchant2, created_at: "2018-08-04 09:00:00 UTC")
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)
    item3 = create(:item, merchant: merchant1)
    item4 = create(:item, merchant: merchant2)
    invoice_item1 = create(:invoice_item, quantity: 2, unit_price: 100, invoice: invoice1, item: item1)
    invoice_item2 = create(:invoice_item, quantity: 4, unit_price: 100, invoice: invoice2, item: item2)
    invoice_item3 = create(:invoice_item, quantity: 6, unit_price: 100, invoice: invoice1, item: item3)
    invoice_item4 = create(:invoice_item, quantity: 8, unit_price: 100, invoice: invoice2, item: item4)
    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')
    transaction4 = create(:transaction, invoice: invoice4, result: 'success')

    get "/api/v1/items/#{item1.id}/most_revenue?quantity=3"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(3)
    expect(result["data"].first["id"].to_i).to eq(item4.id)
  end

end
