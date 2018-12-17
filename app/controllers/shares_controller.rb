class SharesController < ApplicationController
  def index
    if params[:query].present?
      sql_query = "isin ILIKE :query OR currencyspecificisin ILIKE :query OR fundname ILIKE :query"
      @shares = Share.where(sql_query, query: "%#{params[:query]}%")
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
