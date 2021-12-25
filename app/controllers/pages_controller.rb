class PagesController < ApplicationController
  def home
  end

  def search
    @q = params[:q]
    @min = params[:min]
    @max = params[:max]
    @delivery = params[:delivery].present? ? params[:delivery] : "0"
    @sort = params[:sort].present? ? params[:sort] : "price asc"

    @categories = Category.all
    @category = Category.find(params[:category]) unless params[:category].blank?

    # @gigs = Gig.where("category_id = ? AND title ILIKE ? AND active = ?", params[:category], "%#{params[:q]}%", true)

    query_condition = []
    query_condition << "gigs.active = ?"
    query_condition[0] += " AND ((gigs.has_single_price = true and pricings.pricing_type = 0) OR gigs.has_single_price = false)"
    query_condition.push(true)

    unless params[:category].blank?
      query_condition[0] += " AND gigs.category_id = ?"
      query_condition.push(params[:category])
    end

    unless @q.blank?
      query_condition[0] += " AND gigs.title ILIKE ?"
      query_condition.push("%#{@q}%")
    end

    unless @min.blank?
      query_condition[0] += " AND pricings.price >= ?"
      query_condition.push(@min)
    end

    unless @max.blank?
      query_condition[0] += " AND pricings.price <= ?"
      query_condition.push(@max)
    end

    if !@delivery.blank? && @delivery != "0"
      query_condition[0] += " AND pricings.delivery_time <= ?"
      query_condition.push(@delivery)
    end

    @gigs = Gig
                .select("gigs.id, gigs.user_id, gigs.title, MIN(pricings.price) AS price")
                .joins(:pricings)
                .where(query_condition)
                .group("gigs.id")
                .order(@sort)
                .page(params[:page])
                .per(6)

  end
end
