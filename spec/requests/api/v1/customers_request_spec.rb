require 'rails_helper'

describe 'customers API' do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful
    results = JSON.parse(response.body)
    expect(results["data"].count).to eq(3)
  end

  it "sends one customer by id" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(id)
  end

  it "sends one customer at random" do
    create_list(:customer, 3)

    get "/api/v1/customers/random"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result.class).to eq(Hash)
  end

  it "finds one customer by id" do
    test1 = create(:customer)
    test2 = create(:customer)
    get "/api/v1/customers/find?id=#{test2.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(test2.id)
  end

  it "finds one customer by created_at" do
    customer = Customer.create!(created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/customers/find?created_at=#{customer.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(customer.id)
  end

  it "finds one customer by updated_at" do
    customer = Customer.create!(created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")

    get "/api/v1/customers/find?created_at=#{customer.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(customer.id)
  end

  it "finds all customers by created_at" do
    customer1 = Customer.create!(created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    customer2 = Customer.create!(created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    customer3 = Customer.create!(created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/customers/find_all?created_at=#{customer1.created_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all customers by updated_at" do
    customer1 = Customer.create!(created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    customer2 = Customer.create!(created_at: "2018-08-01 09:00:00 UTC", updated_at: "2018-08-01 09:00:00 UTC")
    customer3 = Customer.create!(created_at: "2018-08-02 09:00:00 UTC", updated_at: "2018-08-02 09:00:00 UTC")

    get "/api/v1/customers/find_all?created_at=#{customer1.updated_at}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds all customers by id" do
    customer1 = Customer.create!
    customer2 = Customer.create!
    customer3 = Customer.create!

    get "/api/v1/customers/find_all?id=#{customer1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(1)
  end

  it "finds one customer by case_insensitive first name" do
    test1 = create(:customer, first_name: "Norm")
    test2 = create(:customer, first_name: "Dave")
    get "/api/v1/customers/find?first_name=#{test2.first_name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(test2.id)
  end

  it "finds all customers by case_insensitive first name" do
    test1 = create(:customer, first_name: "Norm")
    test2 = create(:customer, first_name: "Norm")
    get "/api/v1/customers/find_all?name=#{test2.first_name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "finds one customer by case_insensitive last name" do
    test1 = create(:customer, last_name: "Norm")
    test2 = create(:customer, last_name: "Dave")
    get "/api/v1/customers/find?last_name=#{test2.last_name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"]["id"].to_i).to eq(test2.id)
  end

  it "finds all customers by case_insensitive last name" do
    test1 = create(:customer, last_name: "Norm")
    test2 = create(:customer, last_name: "Norm")
    get "/api/v1/customers/find_all?name=#{test2.last_name.downcase}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(2)
  end

  it "returns invoices associated with a customer" do
    customer1 = create(:customer)
    create_list(:invoice, 10, customer_id: customer1.id)
    create_list(:invoice, 10)

    get "/api/v1/customers/:id/invoices?id=#{customer1.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(10)
    expect(result["data"].first["attributes"]["customer_id"]).to eq(customer1.id)
  end

  it "returns transactions associated with a customer" do
    customer = create(:customer)
    invoices = create_list(:invoice, 10, customer_id: customer.id)
    trans = invoices.map do |invoice|
      Transaction.create!(invoice_id: invoice.id)
    end
    ids = trans.map { |i| i.id }
    create_list(:transaction, 5)

    get "/api/v1/customers/:id/transactions?id=#{customer.id}"

    result = JSON.parse(response.body)
    expect(response).to be_successful
    expect(result["data"].count).to eq(10)
    expect(ids).to include(result["data"].first["attributes"]["id"])
  end

end
