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

  private

  def review_params
    params.require(:review).permit(:investment_strategy, :current_strategy)
  end
end
