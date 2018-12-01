require 'rails_helper'

describe 'merchants API' do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    result = JSON.parse(response.body)
    expect(result["data"].count).to eq(3)
  end

  it "sends one merchant by id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(id)
  end

  it "sends one merchant at random" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Dave")

    get "/api/v1/merchants/random"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result.class).to eq(Hash)
  end

  it "finds one merchant by case_insensitive name" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Dave")
    get "/api/v1/merchants/find?name=#{merch2.name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(merch2.id)
  end

  it "finds one merchant by id" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Dave")

    get "/api/v1/merchants/find?id=#{merch2.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(merch2.id)
  end

  it "finds one merchant by created_at" do
    merchant = create(:merchant, name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/merchants/find?created_at='2018-08-01T09:00:00.000Z'"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(merchant.id)
  end

  it "finds one merchant by updated_at" do
    merchant = create(:merchant, name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/merchants/find?created_at=#{merchant.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(merchant.id)
  end

  it "finds all merchants by case_insensitive name" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Norm")
    get "/api/v1/merchants/find_all?name=#{merch2.name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all merchants by created_at" do
    merchant1 = create(:merchant, name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant2 = create(:merchant, name: "Dave", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant3 = create(:merchant, name: "Tim", created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/merchants/find_all?created_at=#{merchant1.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all merchants by updated_at" do
    merchant1 = create(:merchant, name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant2 = create(:merchant, name: "Dave", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant3 = create(:merchant, name: "Tim", created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/merchants/find_all?created_at=#{merchant1.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all merchants by id" do
    merchant1 = create(:merchant, name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant2 = create(:merchant, name: "Dave", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant3 = create(:merchant, name: "Tim", created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/merchants/find_all?id=#{merchant1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "returns items associated with a merchant" do
    merch1 = create(:merchant, name: "Norm")
    create_list(:item, 10, merchant_id: merch1.id)
    create_list(:item, 10)

    get "/api/v1/merchants/:id/items?id=#{merch1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(10)
    expect(result["data"].first["attributes"]["merchant_id"]).to eq(merch1.id)
  end

  it "returns invoices associated with a merchant" do
    merch1 = create(:merchant, name: "Norm")
    create_list(:invoice, 10, merchant_id: merch1.id)
    create_list(:invoice, 10)

    get "/api/v1/merchants/:id/invoices?id=#{merch1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(10)
    expect(result["data"].first["attributes"]["merchant_id"]).to eq(merch1.id)
  end

  it "returns merchants with the most revenue" do
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

    get "/api/v1/merchants/most_revenue?quantity=2"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "returns top x merchants ranked by total number of items sold" do
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

    get "/api/v1/merchants/most_items?quantity=2"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

end
