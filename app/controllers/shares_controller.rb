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

# call le xml pour les isin et results
byebug.pry

    @share = Share.new(share_params)
    @share.performanceid = "0P0000ZWX7"



    respond_to do |format|
      if @share.save
        format.html { redirect_to @shares.post, notice: 'share was successfully created.' }
        format.js   { }
        format.json { render :show, status: :created, location: @share }
      else
        format.html { render :new }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

# methode pour appeler le xml results et checker les différents id

private

  def share_params
    params.require(:share).permit(:performanceid, :isin)
  end
end
