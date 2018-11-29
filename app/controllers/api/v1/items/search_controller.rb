class Api::V1::Items::SearchController < ApplicationController
  def show
    if search_params.permitted? == true
      render json: Item.find_by(search_params)
    else
      render json: Item.random
    end
  end

  def index
    render json: Item.where(search_params)
  end

private

  def search_params
    params.permit(:name, :created_at, :updated_at, :id)
  end

end
