require 'date'

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
    end

    puts @min_periods

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
    d = Date.new(3000, 1, 1)
    list_share_catalog = ShareCatalog.where(share_id: share.id, status: true)

    list_share_catalog.each do |share_catalog|
      company = Company.find(share_catalog.company_id)
      share = Share.find(share_catalog[:share_id])
      period_end = Periodicity.find(company.periodicity_id).period_end unless company.periodicity_id.nil?
      outdated = check_outdated(period_end, share) unless period_end.nil?

      if company.periodicity_id.nil?
        periodicities_hash = { share_id: share_catalog.share_id,
                               company_id: share_catalog.company_id,
                               periodicity_id: 0,
                               period_end: d,
                               outdated: 0 }
      else
        periodicities_hash = { share_id: share_catalog.share_id,
                               company_id: share_catalog.company_id,
                               periodicity_id: company.periodicity_id,
                               period_end: period_end,
                               outdated: outdated }
      end

      periods << periodicities_hash
    end

    return periods
  end

  def check_outdated(period_end, share)
    days_to_date = (period_end - Date.today).to_i
    last_update = (period_end - share.reviews.last.created_at.to_date).to_i unless share.reviews.last.nil?

    return 0 if (!last_update.nil? && last_update < 30) || days_to_date > 12

    if days_to_date <= 12
      return 1
    else
      return 2
    end
  end

  def share_ids_array(share_catalog)
    sia = []
    share_catalog.each do |s|
      sia << s.share_id
    end
    return sia
  end
end
