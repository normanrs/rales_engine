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

end
