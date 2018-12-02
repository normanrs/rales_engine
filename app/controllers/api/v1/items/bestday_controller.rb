class Api::V1::Items::BestdayController < ApplicationController

  def show
    render json: DateSerializer.new(Item.best_day(params[:item_id]))
  end

end
