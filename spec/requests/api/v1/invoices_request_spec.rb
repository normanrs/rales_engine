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
    result = JSON.parse(response.body)
    expect(result["data"].count).to eq(3)
  end

  it "sends one invoice by id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(id)
  end

  it "sends one invoice at random" do
    create_list(:invoice, 3)

    get "/api/v1/invoices/random"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result.class).to eq(Hash)
  end

  it "finds one invoice by status" do
    inv1 = create(:invoice, status: "shipped")
    inv2 = create(:invoice, status: "pending")
    get "/api/v1/invoices/find?status=#{inv2.status}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(inv2.id)
  end

  it "finds one invoice by id" do
    inv1 = create(:invoice)
    inv2 = create(:invoice)
    get "/api/v1/invoices/find?id=#{inv2.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(inv2.id)
  end

  it "finds one invoice by created_at" do
    invoice = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    # get "/api/v1/invoices/find?created_at=#{invoice.created_at}"
    get "/api/v1/invoices/find?created_at='2018-08-01T09:00:00.000Z'"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice.id)
  end

  it "finds one invoice by updated_at" do
    invoice = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/invoices/find?created_at=#{invoice.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(invoice.id)
  end

  it "finds all invoices by status" do
    merch1 = create(:invoice, status: "shipped")
    merch2 = create(:invoice, status: "pending")
    get "/api/v1/invoices/find_all?status=#{merch2.status}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds all invoices by created_at" do
    invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice3 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoices/find_all?created_at=#{invoice1.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all invoices by updated_at" do
    invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice3 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoices/find_all?created_at=#{invoice1.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all invoices by id" do
    invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice3 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoices/find_all?id=#{invoice1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one invoice by merchant_id" do
    inv1 = create(:invoice)
    inv2 = create(:invoice)
    get "/api/v1/invoices/find?merchant_id=#{inv2.merchant_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(inv2.id)
  end

  it "finds all invoices by merchant id" do
    invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    invoice3 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id,created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/invoices/find_all?merchant_id=#{invoice1.merchant_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(3)
  end

  it "finds one invoice by merchant_id" do
    inv1 = create(:invoice)
    inv2 = create(:invoice)
    get "/api/v1/invoices/find?merchant_id=#{inv2.merchant_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(inv2.id)
  end

  it "finds all invoices by merchant id" do
    invoice1 = create(:invoice, merchant_id: @merchant.id)
    invoice2 = create(:invoice, merchant_id: @merchant.id)
    invoice3 = create(:invoice, merchant_id: @merchant.id)

    get "/api/v1/invoices/find_all?merchant_id=#{invoice1.merchant_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(3)
  end

  it "finds one invoice by customer_id" do
    inv1 = create(:invoice)
    inv2 = create(:invoice)
    get "/api/v1/invoices/find?customer_id=#{inv2.customer_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(inv2.id)
  end

  it "finds all invoices by customer_id" do
    invoice1 = create(:invoice, customer_id: @customer.id)
    invoice2 = create(:invoice, customer_id: @customer.id)
    invoice3 = create(:invoice, customer_id: @customer.id)

    get "/api/v1/invoices/find_all?customer_id=#{invoice1.customer_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(3)
  end

end
