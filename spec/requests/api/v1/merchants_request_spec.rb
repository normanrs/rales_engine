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
    merchant = Merchant.create!(name: "Norm", created_at: "2018-08-01 09:00:00", updated_at: "2018-08-01 09:00:00")

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found[:id]).to eq(merchant.id)
    expect(found[:name]).to eq(merchant.name)
  end

  xit "finds one merchant by updated_at" do
    merch1 = create(:merchant, name: "Norm")
    merch2 = create(:merchant, name: "Dave")
    get "/api/v1/merchants/find?name=#{merch2.name}"

    found = JSON.parse(response.body)
    expect(response).to be_successful
    expect(found["id"]).to eq(merch2.id)
  end


end
