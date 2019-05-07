require 'pry-byebug'
class ShareDatasController < ApplicationController
  before_action :call_morningstar_xml_fund, only: [:share_search]

# Get Universe ////////////////////////////////////////////////////////////////
  def call_morningstar_xml_fund
    # secid = params[:secid]
    query = params[:query]

    isin = ''
    secid = ''
    name_query = ''
    unless query.nil? || query.empty?
      if query.match?(/^[A-Z]{2}\d{10}$/)
        isin = query
      elsif query.match?(/^[A-Z0-9]{10}$/)
        secid = query
      else
        name_query = query.gsub!(/\s/,'%20')
      end
    end
    # Univers MS : France
    file = open("http://edw.morningstar.com/GetUniverseXML.aspx?ClientId=EOS&CountryId=FRA&LegalStructureId=&FundShareClassId=" +
                secid +
                "&ISIN=" +
                isin +
                "&Name=" +
                name_query + "&RegionId=&OldestShareClass=&Offshore=&StartDate=&EndDate=&SearchInPrivateList=0&NameSearch=1&ActiveStatus=1")
    @document = Nokogiri::XML(file)
  end

  def share_search
    # URL Exemple : http://localhost:3000//share_datas/share_search?morningstar_data_point=&query=helium%20performance
    morningstar_data_point = params[:morningstar_data_point]

    # *******************************************************
    # Gérer les requetes vides
    # *******************************************************
    if !morningstar_data_point.empty?
      share_data = JSON.parse(parse_xml_morningstar)
      render json: share_data[morningstar_data_point]
    else
      render json: parse_xml_morningstar
    end
  end

  def call_fund_data_output
    # URL Exemple : http://localhost:3000//share_datas/call_fund_data_output?morningstar_data_point=&query=LU0090841262
    query = params[:query]
    query_hash = check_query(query)
    if query_hash[:type] == "isin"
      query = "isin=#{query_hash[:value]}"
    elsif query_hash[:type] == "secid"
      query = "secid=#{query_hash[:value]}"
    else
      query = "erreur"
    end
    file = open("http://edw.morningstar.com/DataOutput.aspx?Package=EDW&ClientId=EOS&" +
                query +
                "&IDTYpe=FundShareClassId&Content=1471&Currencies=BAS&Remove=Strategy,DataStatus,DataGroupList,Operation,TradingInformation,ShareClassAttributes,InternationalFeature,ShareClassNarratives,SP_CodeAndValue,MultilingualVariation,HistoricalOperation,ClassPerformance")
    @document_get_data_output = Nokogiri::XML(file)
    render json: JSON.parse(JSON.generate(parse_data_output_results))
  end

private

  def parse_xml_morningstar
    share = { numbers_result: @document.xpath("/FundShareClassList").children.count,
              result: share_class_result }
    return JSON.generate(share)
  end

  def share_class_result
    array_results = []
    @document.xpath("/FundShareClassList").children.each do |share_class|
      hash_results = { id: share_class.xpath("Id").text,
                       isin: share_class.xpath("ISIN").text,
                       name: share_class.xpath("Name").text,
                       ms_category_id: share_class.xpath("MSCategoryId").text }
      array_results << hash_results
    end
    return array_results
  end

  def parse_data_output_results
    array_results = []
    xpath_fund = @document_get_data_output.xpath("/FundShareClass/Fund")
    xpath_performanceid = @document_get_data_output.xpath("/FundShareClass/PerformanceId")
    xpath_performanceid.children.each do |share_class|
      hash_results = { fund_name: xpath_fund.xpath("FundBasics/Name").text,
                       legal_structure: xpath_fund.xpath("FundBasics/LegalStructure").text,
                       morningstar_category_id: xpath_fund.xpath("FundBasics/@_CategoryId").text,
                       is_isr: xpath_fund.xpath("FundAttributes/SociallyResponsibleFund").text,
                       company_name: xpath_fund.xpath("FundManagement/AdministratorList/AdministratorCompany/Company/CompanyOperation/CompanyBasics/Name").text,
                       currency_id: share_class.xpath("CurrencyId").text,
                       isin: share_class.xpath("PerformanceBasics/ISIN").text,
                       is_base_currency: share_class.xpath("IsBaseCurrency").text,
                       performance_id: share_class.xpath("PerformanceId").text,
                       fund_id: @document_get_data_output.xpath("FundShareClass/@_FundId").text,
                       sec_id: @document_get_data_output.xpath("FundShareClass/@_Id").text }
      array_results << hash_results
    end
    share = { numbers_result: xpath_performanceid.children.count,
              result: array_results }
    return share
  end

  def check_query(value)
    hash_value = {}
    unless value.nil? || value.empty?
      if value.match?(/^[A-Z]{2}\d{10}$/)
        hash_value = { type: "isin",
                       value: value }
      elsif value.match?(/^[A-Z0-9]{10}$/)
        hash_value = { type: "secid",
                       value: value }
      else
        hash_value = { type: "string",
                       value: value.to_s }
      end
    end
    return hash_value
  end
end
