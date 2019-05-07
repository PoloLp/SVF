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
  end

  def show
    @share = Share.find(params[:id])
    @category = Category.where(typecode: @share.morningstarcategoryid).first
  end

  def create

    @share = Share.new(share_params)
    # @share.performanceid = "0P0000ZWX7"
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
end
