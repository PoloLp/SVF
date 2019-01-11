class UserCompaniesController < ApplicationController
  def index
    @user = current_user
    @companies = Company.all
    @share_catalog = ShareCatalog.where(company_id: @companies.ids, status: true)

    @share_catalog_list = Share.where(id: share_ids_array(@share_catalog)).asc_review

    # conserver pour test --------------------
    # @share_catalog_list.each do |share|
    #   if !share.reviews.last.nil?
    #     p "isin : #{share.isin} - fonds : #{share.securityname} #{share.reviews.last.created_at}"
    #   else
    #     p "no review"
    #   end
    # end
    @reviews = Review.where(share_id: @share_catalog_list.ids)
  end

  private

  def share_ids_array(share_catalog)
    sia = []
    share_catalog.each do |s|
      sia << s.share_id
    end
    return sia
  end

  def order_share_catalog(list)
    list.each do |share|
      # p share.reviews.last.nil?
    end

    # list.order(share.reviews.last).desc
  end
end
