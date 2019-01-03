class ShareCatalogsController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @share_catalog = ShareCatalog.where(company_id: params[:company_id])
    @share_catalog_list = Share.where(id: share_ids_array(@share_catalog))

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

  def new
    @company = Company.find(params[:company_id])
    @share_catalog = ShareCatalog.new
  end

  def create
  end

  private

  def share_ids_array(share_catalog)
    sia = []
    share_catalog.each do |s|
      sia << s.share_id
    end
    return sia
  end
end
