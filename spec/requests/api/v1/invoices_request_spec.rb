require 'rails_helper'

describe 'invoices API' do

  before(:each) do
    @customer = create(:customer)
    @merchant = create(:merchant)
  end

  it "sends a list of invoices" do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_successful
    invoices = JSON.parse(response.body)
    expect(invoices["data"].count).to eq(3)
  end

  it "sends one invoice by id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice["data"]["id"].to_i).to eq(id)
  end

  it "sends one invoice at random" do
    merch1 = create(:invoice)
    merch2 = create(:invoice)

    get "/api/v1/invoices/random"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found.class).to eq(Hash)
  end

  it "finds one invoice by status" do
    merch1 = create(:invoice, status: "shipped")
    merch2 = create(:invoice, status: "pending")
    get "/api/v1/invoices/find?status=#{merch2.status}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"]["id"].to_i).to eq(merch2.id)
  end

  it "finds one invoice by id" do
    merch1 = create(:invoice)
    merch2 = create(:invoice)
    get "/api/v1/invoices/find?id=#{merch2.id}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"]["id"].to_i).to eq(merch2.id)
  end

  it "finds one invoice by created_at" do
    invoice = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    # get "/api/v1/invoices/find?created_at=#{invoice.created_at}"
    get "/api/v1/invoices/find?created_at='2018-08-01T09:00:00.000Z'"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"]["id"].to_i).to eq(invoice.id)
  end

  it "finds one invoice by updated_at" do
    invoice = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/invoices/find?created_at=#{invoice.updated_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"]["id"].to_i).to eq(invoice.id)
  end

  it "finds all invoices by status" do
    merch1 = create(:invoice, status: "shipped")
    merch2 = create(:invoice, status: "pending")
    get "/api/v1/invoices/find_all?status=#{merch2.status}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"].count).to eq(1)
  end

  it "finds all invoices by created_at" do
    invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice3 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoices/find_all?created_at=#{invoice1.created_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"].count).to eq(2)
  end

  it "finds all invoices by updated_at" do
    invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice3 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoices/find_all?created_at=#{invoice1.updated_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"].count).to eq(2)
  end

  it "finds all invoices by id" do
    invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice3 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoices/find_all?id=#{invoice1.id}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["data"].count).to eq(1)
  end

end
