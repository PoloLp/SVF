require 'open-uri'
require 'nokogiri'


class SharesController < ApplicationController
  def index
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

  def show
    @share = Share.find(params[:id])
    @category = Category.where(typecode: @share.morningstarcategoryid).first
    @monthly_performance_fund = monthly_performance_morningstar
  end

  def monthly_performance_morningstar
    file = open("http://edw.morningstar.com/DataOutput.aspx?Package=EDW&ClientId=EOS&Id=F000000DUW&IDTYpe=FundShareClassId&Content=1471&Currencies=BAS")
    document = Nokogiri::XML(file)

    fund_monthly_total_return = {
                                  ytd: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M0']/Value").text.to_f,
                                  M12: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f,
                                  M1: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M1']/Value").text.to_f,
                                  M2: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M2']/Value").text.to_f,
                                  M3: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M3']/Value").text.to_f,
                                  M6: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M6']/Value").text.to_f
                                }
    return fund_monthly_total_return
  end

  def share_params
    params.require(:share).permit(:performanceid)
  end
end
