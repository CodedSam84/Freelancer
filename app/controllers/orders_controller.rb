class OrdersController < ApplicationController
  
  before_action :authenticate_user!

  def create
    gig = Gig.find(params[:gig_id])
    pricing = gig.pricings.find_by_pricing_type(params[:pricing_type])

    if (pricing && !gig.has_single_price) || (pricing && gig.has_single_price && pricing.basic?)
      charge(gig, pricing)
    else
      flash[:alert] = "Invalid pricing"
    end

    redirect_to request.referrer
  end

  def selling_orders
    @orders = current_user.selling_orders
  end

  def buying_orders
    @orders = current_user.buying_orders
  end

    def complete
      order = Order.find(params[:id])

      if order.inprogress?
        if order.completed!
          flash[:notice] = "Saved..."
        else
          flash[:alert] = "Something went wrong..."
        end

        redirect_to request.referrer
      end
    end
    
  private

  def charge(gig, pricing)
    order = gig.orders.build
    order.due_date = Date.today + pricing.delivery_time
    order.title = gig.title
    order.amount = pricing.price
    order.seller_name = gig.user.full_name
    order.buyer_name = current_user.full_name
    order.seller_id = gig.user.id
    order.buyer_id = current_user.id

    if order.save
      flash[:notice] = "Order saved successfully"
    else
      flash[:alert] = order.errors.full_messages.join(", ")
    end
  end
end
