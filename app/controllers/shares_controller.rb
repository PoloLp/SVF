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

  def edit_multiple_reviews
    # To fix *************************************************
    @shares = Share.find(params[:share_ids])
  end

  def update_multiple_reviews

    @shares = Share.find(params[:share_ids])

    @shares.reject! do |share|
      share.update_attributes(share_params.reject { |_k, v| v.blank? })
    end
    if @shares.empty?
      redirect_to shares_path(@shares)
      flash[:notice] = "MAJ Stratégies effectuée"
    else
      @share = Review.new(share_params)
      redirect_to shares_path(@shares)
    end
  end

  def share_params
    params.require(:share).permit(:performanceid)
  end
end
