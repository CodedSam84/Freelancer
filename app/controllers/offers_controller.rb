class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: [:accept, :reject]
  before_action :is_authorised, only: [:accept, :reject]

  def create
    req = Request.find(offer_params[:request_id])

    if req && (req.user_id == current_user.id)
      return redirect_to request.referrer, alert: "You cannot create offer for your own request"
    end

    if Offer.exists?(user_id: current_user.id, request_id: offer_params[:request_id])
      return redirect_to request.referrer, alert: "You cannot create multiple offers for the same request"
    end

    offer = current_user.offers.build(offer_params)

    if offer.save
      return redirect_to my_offers_path, notice: "Saved successfully.."
    else
      return redirect_to request.referrer, flash: {error: offer.errors.full_messages.join(", ")}
    end
  end

  def accept
    if @offer.pending?
      @offer.accepted!

      if charge(@offer.request, @offer)
        return redirect_to buying_orders_path, notice: "Order created!"
      else
        flash[:alert] = order.errors.full_messages.join(", ")
      end
    end

    redirect_to request.referrer
  end

  def reject
    if @offer.pending?
      @offer.rejected!
      flash[:notice] = "Offer rejected!"
    end

    redirect_to request.referrer
  end

  def my_offers
    @offers = current_user.offers
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def is_authorised
    redirect_to root_path, alert: "You do not have permission.." unless current_user.id == @offer.request.user_id
  end

  def offer_params
    params.require(:offer).permit(:note, :amount, :days, :request_id, :status)
  end

  def charge(req, offer)
    order = req.orders.build
    order.due_date = Date.today + offer.days
    order.title = req.title
    order.amount = offer.amount
    order.seller_name = offer.user.full_name
    order.buyer_name = current_user.full_name
    order.seller_id = offer.user.id
    order.buyer_id = current_user.id

    order.save
  end
end
