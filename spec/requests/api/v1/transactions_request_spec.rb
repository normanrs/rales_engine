require 'rails_helper'

describe 'transactions API' do

  before(:each) do
    @invoice = create(:invoice)

  end

  it "sends a list of transactions" do
    create_list(:transaction, 3)

    get '/api/v1/transactions'

    expect(response).to be_successful
    result = JSON.parse(response.body)
    expect(result["data"].count).to eq(3)
  end

  it "sends one transaction by id" do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(id)
  end

  it "sends one transaction at random" do
    transaction1 = create(:transaction)
    transaction2 = create(:transaction)

    get "/api/v1/transactions/random"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result.class).to eq(Hash)
  end

  it "finds one transaction by id" do
    transaction1 = create(:transaction)
    transaction2 = create(:transaction)
    get "/api/v1/transactions/find?id=#{transaction2.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(transaction2.id)
  end

  it "finds one transaction by created_at" do
    transaction = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/transactions/find?created_at='2018-08-01T09:00:00.000Z'"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(transaction.id)
  end

  it "finds one transaction by updated_at" do
    transaction = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/transactions/find?created_at=#{transaction.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(transaction.id)
  end

  it "finds all transactions by created_at" do
    transaction1 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    transaction2 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    transaction3 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/transactions/find_all?created_at=#{transaction1.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all transactions by updated_at" do
    transaction1 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    transaction2 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    transaction3 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/transactions/find_all?created_at=#{transaction1.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all transactions by id" do
    transaction1 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    transaction2 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    transaction3 = Transaction.create!(invoice_id: @invoice.id, created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/transactions/find_all?id=#{transaction1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one transaction by invoice_id" do
    transaction1 = create(:transaction)
    transaction2 = create(:transaction)
    get "/api/v1/transactions/find?invoice_id=#{transaction2.invoice_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(transaction2.id)
  end

  it "finds all transactions by invoice_id" do
    transaction1 = create(:transaction)
    transaction2 = create(:transaction)
    get "/api/v1/transactions/find_all?invoice_id=#{transaction2.invoice_id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one transaction by credit_card_number" do
    transaction1 = create(:transaction, credit_card_number: 4444333322221111)
    transaction2 = create(:transaction, credit_card_number: 8888777766665555)
    get "/api/v1/transactions/find?credit_card_number=#{transaction2.credit_card_number}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(transaction2.id)
  end

  it "finds all transactions by credit_card_number" do
    transaction1 = create(:transaction, credit_card_number: 4444333322221111)
    transaction2 = create(:transaction, credit_card_number: 8888777766665555)
    get "/api/v1/transactions/find_all?credit_card_number=#{transaction2.credit_card_number}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one transaction by credit_card_expiration_date" do
    transaction1 = create(:transaction, credit_card_expiration_date: 1.day.ago)
    transaction2 = create(:transaction, credit_card_expiration_date: 2.days.ago)
    get "/api/v1/transactions/find?credit_card_expiration_date=#{transaction2.credit_card_expiration_date}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(transaction2.id)
  end

  it "finds all transactions by credit_card_expiration_date" do
    transaction1 = create(:transaction, credit_card_expiration_date: 1.day.ago)
    transaction2 = create(:transaction, credit_card_expiration_date: 2.days.ago)
    get "/api/v1/transactions/find_all?credit_card_expiration_date=#{transaction2.credit_card_expiration_date}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one transaction by result" do
    transaction1 = create(:transaction, result: "success")
    transaction2 = create(:transaction, result: "failed")
    get "/api/v1/transactions/find?result=#{transaction2.result}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(transaction2.id)
  end

  it "finds all transactions by result" do
    transaction1 = create(:transaction, result: "success")
    transaction2 = create(:transaction, result: "failed")
    get "/api/v1/transactions/find_all?result=#{transaction2.result}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "returns invoice associated with a transaction" do
    transaction1 = create(:transaction)

    get "/api/v1/transactions/:id/invoice?id=#{transaction1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["attributes"]["id"]).to eq(transaction1.invoice_id)
  end


end
