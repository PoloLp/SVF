class UserCompaniesController < ApplicationController
  def index
    @user = current_user
    @companies = Company.all
    @share_catalog = ShareCatalog.where(company_id: @companies.ids, status: true)
    @share_catalog = @share_catalog.order('updated_at DESC')
    @share_catalog_list = Share.where(id: share_ids_array(@share_catalog))
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
