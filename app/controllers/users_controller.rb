class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_user, only: [:show, :destroy]

  def show
    @deals_reviewed = @user.deals_reviewed.page(params[:page])
  end

  def dashboard
    @user = current_user
    authorize @user
  end

  def destroy
    @user.destroy
    flash[:alert] = "Your account has been cancelled"
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find(params[:id])
    authorize @user
  end

end
