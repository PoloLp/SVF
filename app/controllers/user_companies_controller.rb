require 'byebug'
class UserCompaniesController < ApplicationController
  def index
    @user = current_user
    @companies = Company.all
    @share_catalog = ShareCatalog.where(company_id: @companies.ids, status: true)

    @share_catalog_list = Share.where(id: share_ids_array(@share_catalog)).asc_review

    @share_catalog_list.each do |share|
      p "Resultat méthiode #{share_periodicity(share)}"
    end

    # conserver pour test --------------------
    # @share_catalog_list.each do |share|
    #   if !share.reviews.last.nil?
    #     p "isin : #{share.isin} - fonds : #{share.securityname} #{share.reviews.last.created_at}"
    #   else
    #     p "no review"
    #   end
    # end
    @reviews = Review.where(share_id: @share_catalog_list.ids)

    @companies.each do |company|
      company.periodicity_id = 1
    end
  end

  respond_to do |format|
    format.html
  end

  def share_periodicity(share)
    list_share_catalog = ShareCatalog.where(share_id: share.id, status: true)

    periods = []

    list_share_catalog.each do |share_catalog|
      periodicities_hash = Hash.new
      periodicities_hash = { share_id: share_catalog.share_id,
                             company_id: share_catalog.company_id,
                             periodicity_id: Company.find(share_catalog.company_id).periodicity_id }

      periods << periodicities_hash unless periodicities_hash[:periodicity_id].nil?
    end

# ***************************************************************************
      # puts periods.max_by { |k| k[:periodicity_id] }[:periodicity_id] unless periods.empty?
# ***************************************************************************

    return periods unless periods.empty?

    return 0
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
