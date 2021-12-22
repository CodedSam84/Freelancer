class ReviewsController < ApplicationController
  def create
    @order = Order.find(review_params[:order_id])

    if @order && (current_user.id == @order.buyer.id)
      if Review.exists?(order_id: review_params[:order_id], buyer_id: current_user.id)
        flash[:alert] = "You already created review for this order"
      else
        if review.save
          flash[:notice] = "Thank you. Your review has been successfully created!"
        else
          flash[:alert] = "Review cannot be saved..."
        end
      end
    else
      flash[:alert] = "Invalid order"
    end

    redirect_to request.referrer
  end

  private

  def review_params
    params.require(:review).permit(:review, :order_id, :stars)
  end

  def review
    new_review = Review.new(review_params)
    new_review.gig = @order.gig
    new_review.buyer = current_user
    new_review.seller = @order.seller
    new_review
  end
end