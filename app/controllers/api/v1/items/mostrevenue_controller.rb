class Api::V1::Items::MostrevenueController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.most_revenue(search_params))
  end

  private

    def search_params
      params.require(:quantity)
    end


end
