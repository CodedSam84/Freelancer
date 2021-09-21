class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    if current_user.update(current_user_params)
      flash[:notice] = 'Record successfully updated!'
    else
      flash[:alert] = 'Record could not be updated!'
    end

    redirect_to dashboard_path
  end

  private

  def current_user_params
    params.require(:user).permit(:about, :from, :status, :language, :avatar)
  end
end
