class SharesController < ApplicationController
  def index
    puts params[:currency_query]
    puts params[:currency_query].empty?
    if params[:query].present?
      sql_query = "(isin ILIKE :query OR currencyspecificisin ILIKE :query OR fundname ILIKE :query)"
        sql_query += " AND currencyid= :currency_query" if !params[:currency_query].empty?
      @shares = Share.where(sql_query, query: "%#{params[:query]}%",
                                       currency_query: "#{params[:currency_query]}")
      @isin_search = params[:query]
    else
      @shares = []
    end
  end

  def show
    @share = Share.find(params[:id])
  end

  def share_params
    params.require(:share).permit(:performanceid)
  end
end
