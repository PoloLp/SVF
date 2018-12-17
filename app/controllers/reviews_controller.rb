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
    @shares = Share.find(params[:share_ids])
  end

  def create_multiple
    # we need `share_id` to asssociate review with corresponding share
    @shares = Share.find(params[:share_ids])
    @shares.each do |share|
      review_field = review_params
      if review_field[:investment_strategy].nil?
        review_field[:investment_strategy] = share.reviews.last.investment_strategy
      elsif review_field[:current_strategy].nil?
        review_field[:current_strategy] = share.reviews.last.current_strategy
      end
      @review = Review.new(review_field)
      @review.share = share
      @review.save
    end
    redirect_to shares_path(@shares)
    flash[:notice] = "MAJ Stratégies effectuée"
  end

  private

  def review_params
    params.require(:review).permit(:investment_strategy, :current_strategy)
  end
end
