class Api::V1::Merchants::RevenueController < ApplicationController
require 'ostruct'

  def show
    if params[:date] != nil
      money_in = OpenStruct.new(:id => 1,
                                :money => Merchant.revenue(search_params[:date]) )
      render json: MoneySerializer.new(money_in)
    else
      merch = Merchant.find(search_params[:merchant_id])
      merch_in = OpenStruct.new(:id => merch.id,
                                :name => merch.name,
                                :created_at => merch.created_at,
                                :updated_at => merch.updated_at,
                                :revenue => merch.money_made.to_i )
      render json: MerchantsumSerializer.new(merch_in)
    end
  end

private

  def search_params
    params.permit(:id, :merchant_id, :date)
  end

end
