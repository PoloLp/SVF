class ShareDatasController < ApplicationController
  before_action :call_morningstar_xml_fund, only: [:share_search]
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
end
