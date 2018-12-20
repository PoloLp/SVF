class ShareCatalogsController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @share_catalog = ShareCatalog.where(company_id: params[:company_id])
    @shares = Share.where(id: share_ids_array(@share_catalog))
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
