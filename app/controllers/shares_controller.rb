class SharesController < ApplicationController
  def isin_search(isin_code)
    fund_share = []
    fund_share = Share.where(isin: isin_code)
    return fund_share
  end
end
