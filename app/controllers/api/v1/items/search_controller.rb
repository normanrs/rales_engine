class Api::V1::Items::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: ItemSerializer.new(Item.find_by(search_params))
    else
      render json: ItemSerializer.new(Item.random)
    end
  end

  def index
    render json: ItemSerializer.new(Item.where(search_params))
  end

private

  def search_params
    params.permit(:unit_price, :merchant_id, :name, :description, :created_at, :updated_at, :id)
  end

end
