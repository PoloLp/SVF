require "byebug"
class ChartsController < ApplicationController
  before_action :call_morningstar_xml_fund, only: [:share_performance_rolling_period, :share_performance_calendar_period]

  def call_morningstar_xml_fund
    secid = params[:secid]
    file = open("http://edw.morningstar.com/DataOutput.aspx?Package=EDW&ClientId=EOS&Id=" + secid + "&IDTYpe=FundShareClassId&Content=1471&Currencies=BAS")
    @document = Nokogiri::XML(file)
  end

  def share_performance_rolling_period
    render json: monthly_performance_morningstar
  end

  def share_performance_calendar_period
    render json: calendar_performance_morningstar
  end

  private

  def monthly_performance_morningstar
    fund_monthly_total_return = {
                                  "Year to date": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M0']/Value").text.to_f.round(2),
                                  "1 an": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "1 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M1']/Value").text.to_f.round(2),
                                  "2 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M2']/Value").text.to_f.round(2),
                                  "3 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M3']/Value").text.to_f.round(2),
                                  "6 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M6']/Value").text.to_f.round(2)
                                }
    return fund_monthly_total_return
  end

  def calendar_performance_morningstar

puts "2018"
puts @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2018']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2)

    fund_calendar_total_return = {
                                  "2018": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2018']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "2017": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2017']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "2016": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2016']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "2015": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2015']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "2014": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2014']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "2013": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2013']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                }
    return fund_calendar_total_return
  end
end
