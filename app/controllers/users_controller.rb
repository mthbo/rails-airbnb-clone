class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_user, only: [:show]
  before_action :find_current_user, only: [:country, :update_country, :dashboard, :details, :update, :change_locale]
  layout 'advisor_form', only: [:country, :update_country, :details, :update]

  def show
    @deals_reviewed = @user.deals_reviewed.page(params[:page])
  end

  def dashboard
    @pinned_offers = @user.find_liked_items
  end

  def details
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t('.notice')
      redirect_to user_path(@user)
    else
      render :details
    end
  end

  def country
  end

  def update_country
    if @user.update(user_params)
      redirect_to new_offer_path
    else
      render :country
    end
  end

  def change_locale
    @user.update(locale: params[:locale])
    redirect_to params[:path]
  end

  private

  def find_user
    @user = User.find(params[:id])
    authorize @user
  end

  def find_current_user
    @user = current_user
    authorize @user
  end

  def user_params
    params.require(:user).permit(:country_code, :first_name, :last_name, :birth_date, :address, :city, :zip_code, :legal_type, :business_name, :business_tax_id, :personal_address, :personal_city, :personal_zip_code, :pricing, :bank_name, :bank_last4)
  end

end
