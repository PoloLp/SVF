class SharesController < ApplicationController
  def index
    if params[:query].present?
      sql_query = "isin ILIKE :query OR currencyspecificisin ILIKE :query OR fundname ILIKE :query"
      @shares = Share.where(sql_query, query: "%#{params[:query]}%")
      @isin_search = params[:query]
    else
      @shares = []
    end
  end

  def show
    @share = Share.find(params[:id])
  end

  def edit_individual
    # To fix *************************************************
    flash[:notice] = "T'est dans edit_individual"
    @shares = Share.find(params[:share_ids])
  end

  def update_edit_individual
    flash[:notice] = "T'es dans update_edit_individual"
    # byebug
    # @shares = Share.update(params[:shares].keys, params[:shares].values).reject { |p| p.errors.empty? }
    # if @shares.empty?
    #   flash[:notice] = "Products updated"
    #   redirect_to shares_url
    # else
    #   render :action => "edit_individual"
    # end
  end
end
