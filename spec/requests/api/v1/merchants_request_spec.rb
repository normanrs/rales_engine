require 'rails_helper'

describe 'merchants API' do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants.count).to eq(3)
  end

  it "sends one merchant by id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it "sends one merchant at random" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Dave")

    get "/api/v1/merchants/random"

    roll = JSON.parse(response.body)
    expect(response).to be_successful
    expect(roll.class).to eq(Hash)
  end

  it "finds one merchant by name" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Dave")
    get "/api/v1/merchants/find?name=#{merch2.name}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["id"]).to eq(merch2.id)
  end

  it "finds one merchant by id" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Dave")
    get "/api/v1/merchants/find?id=#{merch2.id}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["id"]).to eq(merch2.id)
  end

  it "finds one merchant by created_at" do
    merchant = Merchant.create!(name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["id"]).to eq(merchant.id)
  end

  it "finds one merchant by updated_at" do
    merchant = Merchant.create!(name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/merchants/find?created_at=#{merchant.updated_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["id"]).to eq(merchant.id)
  end

  it "finds all merchants by name" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Norm")
    get "/api/v1/merchants/find_all?name=#{merch2.name}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found.count).to eq(2)
  end

  it "finds all merchants by created_at" do
    merchant1 = Merchant.create!(name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant2 = Merchant.create!(name: "Dave", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant3 = Merchant.create!(name: "Tim", created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/merchants/find_all?created_at=#{merchant1.created_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found.count).to eq(2)
  end

  it "finds all merchants by updated_at" do
    merchant1 = Merchant.create!(name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant2 = Merchant.create!(name: "Dave", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant3 = Merchant.create!(name: "Tim", created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/merchants/find_all?created_at=#{merchant1.updated_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found.count).to eq(2)
  end

  it "finds all merchants by id" do
    merchant1 = Merchant.create!(name: "Norm", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant2 = Merchant.create!(name: "Dave", created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    merchant3 = Merchant.create!(name: "Tim", created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/merchants/find_all?id=#{merchant1.id}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found.count).to eq(1)
  end

end
