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

  def update
    byebug
    @share_catalog = ShareCatalog.find(params[:id])
    @share_catalog.update(params[:share_catalog])
  end

  def selected
    @company = Company.find(params[:company_id])
    @shares = Share.find(params[:share_ids])

    @shares.each do |share|
      @share_catalog = ShareCatalog.new
      @share_catalog.company = @company
      @share_catalog.share = share
      @share_catalog.status = true
      @share_catalog.save
    end
    redirect_to company_share_catalogs_path(@company)
    flash[:notice] = "#{@shares.count} funds added to the list"
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
