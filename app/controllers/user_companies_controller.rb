require 'byebug'
class UserCompaniesController < ApplicationController
  def index
    @user = current_user
    @companies = Company.all
    @share_catalog = ShareCatalog.where(company_id: @companies.ids, status: true)

    @share_catalog_list = Share.where(id: share_ids_array(@share_catalog)).asc_review

    @min_periods = []

    @share_catalog_list.each do |share|
      min_date = share_periodicity(share)

      @min_periods << min_date.min_by { |k| k[:period_end] }
    puts "*" * 100
    puts "#{share.securityname} --> #{min_date.min_by { |k| k[:period_end] }} "
    puts "*" * 200
    puts "résultat #{min_date.min_by { |k| k[:period_end] }}"

    end

    puts @min_periods
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

  private

  def share_periodicity(share)
    periods = []
    d = Time.new(3000, 1, 1)
    list_share_catalog = ShareCatalog.where(share_id: share.id, status: true)

    list_share_catalog.each do |share_catalog|
      company = Company.find(share_catalog.company_id)
      period_end = Periodicity.find(company.periodicity_id).period_end unless company.periodicity_id.nil?

      if company.periodicity_id.nil?
        periodicities_hash = { share_id: share_catalog.share_id,
                               company_id: share_catalog.company_id,
                               periodicity_id: 0,
                               period_end: d }
      else
        periodicities_hash = { share_id: share_catalog.share_id,
                               company_id: share_catalog.company_id,
                               periodicity_id: company.periodicity_id,
                               period_end: period_end }
      end
      periods << periodicities_hash
    end
    return periods
  end

  def share_ids_array(share_catalog)
    sia = []
    share_catalog.each do |s|
      sia << s.share_id
    end
    return sia
  end
end
