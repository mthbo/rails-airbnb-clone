class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_user, only: [:show]
  layout 'advisor_form', only: [:stripe_connection]

  def show
    @deals_reviewed = @user.deals_reviewed.page(params[:page])
  end

  def dashboard
    @user = current_user
    authorize @user
    @pinned_offers = @user.find_liked_items
  end

  def stripe_connection
    @user = current_user
    authorize @user
  end

  def change_locale
    @user = current_user
    authorize @user
    @user.update(locale: params[:locale])
    redirect_to params[:path]
  end

  private

  def find_user
    @user = User.find(params[:id])
    authorize @user
  end

end
