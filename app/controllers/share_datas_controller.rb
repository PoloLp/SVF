class ShareDatasController < ApplicationController
  before_action :call_morningstar_xml_fund, only: [:share_search]
# mettre le get universe
  def call_morningstar_xml_fund
    secid = params[:secid]
    file = open("http://edw.morningstar.com/GetUniverseXML.aspx?ClientId=EOS&CountryId=FRA&LegalStructureId=&FundShareClassId=" +
                secid +
                "&ISIN=&Name=&RegionId=&OldestShareClass=&Offshore=&StartDate=&EndDate=&SearchInPrivateList=0&NameSearch=1&ActiveStatus=1")
    @document = Nokogiri::XML(file)
  end

def share_search
  # URL Exemple : http://localhost:3000//share_datas/share_search?morningstar_data_point=&secid=F000000DUW
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
    share = { numbers_result: @document.xpath("//FundShareClassList").children.count,
              result: @document.xpath("/FundShareClassList") }
    return JSON.generate(share: share)
  end
end
