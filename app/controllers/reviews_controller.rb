# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  def new
    # we need @share in our `simple_form_for`
    @share = Share.find(params[:share_id])
    @review = Review.new
  end

  def create
    @share = Share.find(params[:share_id])
    @review = Review.new(review_params)
    # we need `share_id` to asssociate review with corresponding share
    @review.share = @share
    if @review.save
      redirect_to share_path(@share)
    else
      render :new
    end
  end

  def new_multiple
    # we need @share in our `simple_form_for`
    @shares = Share.find(params[:share_ids])
  end

  def create_multiple
    # we need `share_id` to asssociate review with corresponding share
    @shares = Share.find(params[:share_ids])
    @shares.each do |share|
      @review = Review.new(review_params)
      @review.share = share
      @review.save
    end

    redirect_to shares_path(@shares)
    flash[:notice] = "MAJ Stratégies effectuée"

    # if @review.save
    #   redirect_to share_path(@share)
    # else

    # end
  end

  private

  def review_params
    params.require(:review).permit(:investment_strategy, :current_strategy)
  end

  def share_review_params
    params.require(:share).permit(:investment_strategy, :current_strategy)
  end
end
