class Api::V1::Merchants::RevenueController < ApplicationController
require 'ostruct'

  def show
    if params[:date] != nil
      money_in = OpenStruct.new(:id => 1, :money => Merchant.revenue(search_params[:date]) )
      render json: MoneySerializer.new(money_in)
    else
      merch = Merchant.find(search_params[:merchant_id])
      money_in = OpenStruct.new(:id => merch.id, :money => (merch.money_made) )
      render json: MoneySerializer.new(money_in)
    end
  end


private

  def search_params
    params.permit(:id, :merchant_id, :date)
  end


end
