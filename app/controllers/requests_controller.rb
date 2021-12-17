class RequestsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :list]
  before_action :is_authorised, only: [:edit, :update, :destroy]

  def index
    @requests = current_user.requests
  end

  def show
  end

  def new
    @request = current_user.requests.build
  end

  def create
    @request = current_user.requests.build(request_params)

    if @request.save
      redirect_to requests_path, notice: "Save successfully.."
    else
      redirect_to request.referrer, flash: {error: @request.errors.full_messages.join(", ")}
    end
  end

  def edit
  end

  def update
    if @request.update(request_params)
      redirect_to requests_path, notice: "Save successfully.."
    else
      redirect_to request.referrer, flash: {error: @request.errors.full_messages.join(", ")}
    end
  end

  def destroy
    @request.destroy
    redirect_to request.referrer, notice: "Removed..."
  end

  def list
  end
end

private

def set_categories
  @categories = Category.all
end

def set_request
  @request = Request.find(params[:id])
end

def request_params
  params.require(:request).permit(:title, :description, :delivery, :file, :budget, :category_id)
end

def is_authorised
  redirect_to root_path, alert: "You don't have permission..." unless current_user.id = @request.user_id
end