class ReviewsController < ApplicationController
  def new
    new = Review.new
  end

  def show

  end

  def create
    @review = Review.new(review_params)
    # @review.share =

    if @review.save
      redirect_to review_path(@review)
    else
      render :new
    end
  end
end
