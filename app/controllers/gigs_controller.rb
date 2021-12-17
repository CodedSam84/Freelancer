class GigsController < ApplicationController
  
  protect_from_forgery except: [:upload_photo]
  before_action :authenticate_user!, except: [:show]
  before_action :set_gig, except: [:new, :create]
  before_action :is_authorised, only: [:edit, :update, :upload_photo, :delete_photo]
  before_action :set_step, only: [:edit, :update]

  def new
    @gig = current_user.gigs.build
    @categories = Category.all
  end

  def create
    @gig = current_user.gigs.build(gig_params)

    if @gig.save
      @gig.pricings.create(Pricing.pricing_types.values.map {|x| { pricing_type: x} })
      redirect_to edit_gig_path(@gig, step: 1), notice: "Saved..."
    else
      redirect_to request.referrer, flash: {error: @gig.errors.full_messages}
    end
  end

  def show
    @categories = Category.all
  end

  def edit
    @categories = Category.all
  end

  def update
    if @step == 1 && (gig_params[:title].blank? || gig_params[:category_id].blank?)
      return redirect_to request.referrer, flash: {error: "You must select Title and Category to proceed"}
    end

    if @step == 2
      gig_params[:pricings_attributes].each do |index, pricing|
        if pricing[:pricing_type] != "basic"
          next
        else 
          if pricing[:title].blank? || pricing[:description].blank? || pricing[:delivery_time].blank? || pricing[:price].blank?
            return redirect_to request.referrer, flash: {error: "Invalid pricing, please enter all fields correctly"}
          end
        end
      end
    end

    if @step == 3 && gig_params[:description].blank?
      return redirect_to request.referrer, flash: {error: "Description can't be blank"}
    end

    if @step == 4 && @gig.photos.blank?
      return redirect_to request.referrer, flash: {error: "You do not have photos attached"}
    end

    if @step == 5 
      @gig.pricings.each do |pricing|
        if @gig.has_single_price && pricing != Pricing.pricing_types[:basic]
          next
        else
          if pricing.title.blank? || pricing.description.blank? || pricing.delivery_time.blank? || pricing.price.blank?
            return redirect_to edit_gig_path(@gig, step: 2), flash: {error: "Invalid pricing, please enter all fields correctly"}
          end
        end
      end

      if @gig.description.blank?
        return redirect_to edit_gig_path(@gig, step: 3), flash: {error: "Description can't be blank"}
      end

      if @gig.photos.blank?
        return redirect_to edit_gig_path(@gig, step: 4), flash: {error: "You do not have photos attached"}
      end
    end

    if @gig.update(gig_params)
      flash[:notice] = "Saved succesfully"
    else
      return redirect_to request.referrer, flash: {error: @gig.errors.full_messages}
    end

    if @step < 5
      redirect_to edit_gig_path(@gig, step: @step + 1)
    else
      redirect_to dashboard_path
    end

  end

  def upload_photo
    @gig.photos.attach(params[:file])
    render json: {success: true}
  end

  def delete_photo
    @photo = ActiveStorage::Attachment.find(params[:photo_id])
    @photo.purge
    redirect_to edit_gig_path(@gig, step: 4)
  end

  private

  def set_gig
    @gig = Gig.find(params[:id])
  end

  def set_step
    @step = params[:step].to_i > 0 ? params[:step].to_i : 1
    if @step > 5
      @step = 5
    end
  end

  def gig_params
    params.require(:gig).permit(:title, :video, :active, :has_single_price, :description, :category_id,
                                pricings_attributes: [:title, 
                                                      :description, 
                                                      :delivery_time, 
                                                      :price, 
                                                      :pricing_type,
                                                      :id])
  end

  def is_authorised
    redirect_to root_path, alert: "You do not have permission.." unless current_user.id == @gig.user_id
  end
end
