class SharesController < ApplicationController

  def index
    if params[:query].present?
      sql_query = "isin ILIKE :query OR currencyspecificisin ILIKE :query"
      @shares = Share.where(sql_query, query: "%#{params[:query]}%")
    else
      @shares = Share.all
    end
  end

  def isin_search(isin_code)
    fund_share = []
    fund_share = Share.where(isin: isin_code)
    return fund_share
  end
end
