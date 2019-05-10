require 'open-uri'
require 'nokogiri'
require 'byebug'

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

    @share = Share.new()
  end

  def show
    @share = Share.find(params[:id])
    @category = Category.where(typecode: @share.morningstarcategoryid).first
  end

  def new
    @share = Share.new(isin: "#{helpers.test_helper}")
  end

  def create
    @share = Share.new(share_params)

    @share = fetch_data_output(share_params[:isin])
    binding.pry

    # Iterer sur les @shares du json si il y en a plusieurs

    if @share.save
      respond_to do |format|
        format.html { render 'shares/create', share: @share }
        format.js  # <-- will render `app/views/shares/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'shares/show' }
        format.js  # <-- idem
      end
    end
  end

  private

  def share_params
    params.require(:share).permit(:performanceid, :isin)
  end

  def fetch_data_output(isin)

# ça déconne ici : il ne trouve rien à ouvrir en suivant le lien :
# Errno::ENOENT (No such file or directory @ rb_sysopen - http://localhost:3000//share_datas/call_fund_data_output?morningstar_data_point=&query=LU0090841262):


    filepath = "http://localhost:3000//share_datas/call_fund_data_output?morningstar_data_point=&query=LU0090841262"
    serialized_shares = File.read(filepath)
    shares = JSON.parse(serialized_shares)
    return shares
  end
end
