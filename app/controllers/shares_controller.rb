require 'open-uri'
require 'nokogiri'

class SharesController < ApplicationController
  def index
    if params[:query].present?
      sql_query = "(isin ILIKE :query OR currencyspecificisin ILIKE :query OR fundname ILIKE :query)"
      unless params[:currency_query].nil?
        if !params[:currency_query].empty?
          sql_query += " AND currencyid= :currency_query"
        end
      end
      @shares = Share.where(sql_query, query: "%#{params[:query]}%",
                                       currency_query: "#{params[:currency_query]}")
      @isin_search = params[:query]
    else
      @shares = []
    end
  end

  def show
    @share = Share.find(params[:id])
    @category = Category.where(typecode: @share.morningstarcategoryid).first
  end

  def share_params
    params.require(:share).permit(:performanceid)
  end
end
