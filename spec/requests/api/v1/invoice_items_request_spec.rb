require 'rails_helper'

describe 'invoice_items API' do

  before(:each) do
    @item = create(:item)
    @invoice = create(:invoice)

  end

  it "sends a list of invoice_items" do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful
    result = JSON.parse(response.body)
    expect(result["data"].count).to eq(3)
  end

  it "sends one invoice_item by id" do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(id)
  end

  it "sends one invoice_item at random" do
    invoice_item1 = create(:invoice_item)
    invoice_item2 = create(:invoice_item)

    get "/api/v1/invoice_items/random"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result.class).to eq(Hash)
  end

  it "finds one invoice_item by id" do
    invoice_item1 = create(:invoice_item)
    invoice_item2 = create(:invoice_item)
    get "/api/v1/invoice_items/find?id=#{invoice_item2.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice_item2.id)
  end

  it "finds one invoice_item by created_at" do
    invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    # get "/api/v1/invoice_items/find?created_at=#{invoice_item.created_at}"
    get "/api/v1/invoice_items/find?created_at='2018-08-01T09:00:00.000Z'"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice_item.id)
  end

  it "finds one invoice_item by updated_at" do
    invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/invoice_items/find?created_at=#{invoice_item.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice_item.id)
  end

  it "finds all invoice_items by created_at" do
    invoice_item1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice_item2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice_item3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoice_items/find_all?created_at=#{invoice_item1.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all invoice_items by updated_at" do
    invoice_item1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice_item2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice_item3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoice_items/find_all?created_at=#{invoice_item1.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all invoice_items by id" do
    invoice_item1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice_item2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice_item3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoice_items/find_all?id=#{invoice_item1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one invoice_item by quantity" do
    invoice_item1 = create(:invoice_item, quantity: "40")
    invoice_item2 = create(:invoice_item, quantity: "80")
    get "/api/v1/invoice_items/find?quantity=#{invoice_item2.quantity}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice_item2.id)
  end

  it "finds all invoice_items by quantity" do
    invoice_item1 = create(:invoice_item, quantity: 40)
    invoice_item2 = create(:invoice_item, quantity: 80)
    get "/api/v1/invoice_items/find_all?quantity=#{invoice_item2.quantity}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one invoice_item by unit_price" do
    invoice_item1 = create(:invoice_item, unit_price: 40)
    invoice_item2 = create(:invoice_item, unit_price: 80)
    get "/api/v1/invoice_items/find?unit_price=#{invoice_item2.unit_price}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice_item2.id)
  end

  it "finds all invoice_items by unit_price" do
    invoice_item1 = create(:invoice_item, unit_price: 40)
    invoice_item2 = create(:invoice_item, unit_price: 80)
    get "/api/v1/invoice_items/find_all?unit_price=#{invoice_item2.unit_price}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one invoice by invoice_id" do
    invoice_item1 = create(:invoice_item)
    invoice_item2 = create(:invoice_item)
    get "/api/v1/invoice_items/find?invoice_id=#{invoice_item2.invoice_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice_item2.id)
  end

  it "finds all invoices by invoice id" do
    invoice_item1 = create(:invoice_item, invoice_id: @invoice.id)
    invoice_item2 = create(:invoice_item, invoice_id: @invoice.id)
    invoice_item3 = create(:invoice_item, invoice_id: @invoice.id)

    get "/api/v1/invoice_items/find_all?invoice_id=#{invoice_item1.invoice_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(3)
  end

  it "finds one invoice by item_id" do
    invoice_item1 = create(:invoice_item)
    invoice_item2 = create(:invoice_item)
    get "/api/v1/invoice_items/find?item_id=#{invoice_item2.item_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice_item2.id)
  end

  it "finds all invoices by item_id" do
    invoice_item1 = create(:invoice_item, item_id: @item.id)
    invoice_item2 = create(:invoice_item, item_id: @item.id)
    invoice_item3 = create(:invoice_item, item_id: @item.id)

    get "/api/v1/invoice_items/find_all?item_id=#{invoice_item1.item_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(3)
  end

  it "returns invoice associated with an invoice_item" do
    invoice_item1 = create(:invoice_item)

    get "/api/v1/invoice_items/:id/invoice?id=#{invoice_item1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["attributes"]["id"]).to eq(invoice_item1.invoice_id)
  end

  it "returns item associated with an invoice_item" do
    invoice_item1 = create(:invoice_item)

    get "/api/v1/invoice_items/:id/item?id=#{invoice_item1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["attributes"]["id"]).to eq(invoice_item1.item_id)
  end


end
