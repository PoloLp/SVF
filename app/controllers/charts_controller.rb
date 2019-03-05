require "byebug"

class ChartsController < ApplicationController
  before_action :call_morningstar_xml_fund, only: [:share_performance_rolling_period, :share_performance_calendar_period, :share_morningstar_data]

  def call_morningstar_xml_fund
    secid = params[:secid]
    file = open("http://edw.morningstar.com/DataOutput.aspx?Package=EDW&ClientId=EOS&Id=" +
                secid +
                "&IDTYpe=FundShareClassId&Content=1471&Currencies=BAS")
    @document = Nokogiri::XML(file)
  end

  # def share_performance_rolling_period
  #   render json: monthly_performance_morningstar
  # end

  def share_morningstar_data
    # URL Exemple : http://localhost:3000//charts/share-morningstar-data?morningstar_data_point=&secid=F000000DUW
    morningstar_data_point = params[:morningstar_data_point]
    if !morningstar_data_point.empty?
      share_data = JSON.parse(parse_xml_morningstar)
      render json: share_data[morningstar_data_point]
    else
      render json: parse_xml_morningstar
    end
  end

  private

  def parse_xml_morningstar
    fund_monthly_total_return = {
                                  "1 an": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "6 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M6']/Value").text.to_f.round(2),
                                  "3 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M3']/Value").text.to_f.round(2),
                                  "2 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M2']/Value").text.to_f.round(2),
                                  "1 mois": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M1']/Value").text.to_f.round(2),
                                  "Year to date": @document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M0']/Value").text.to_f.round(2)
    }

    annee = Time.current.year.to_i
    fund_calendar_total_return = {
                                  "#{(annee - 1)}": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2018']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "#{(annee - 2)}": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2017']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "#{(annee - 3)}": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2016']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "#{(annee - 4)}": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2015']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "#{(annee - 5)}": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2014']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
                                  "#{(annee - 6)}": @document.xpath("/FundShareClass/ClassPerformance/Performance/HistoricalPerformance/HistoricalPerformanceDetail[@Year='2013']/ReturnHistory/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f.round(2),
    }

    return JSON.generate(fund_monthly_total_return: fund_monthly_total_return,
                         fund_calendar_total_return: fund_calendar_total_return)
  end
end
