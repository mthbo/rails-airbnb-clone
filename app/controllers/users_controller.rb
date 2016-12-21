class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_user, only: [:show]

  def show
  end

  def dashboard
    @user = current_user
    authorize @user
  end

  private

  def find_user
    @user = User.find(params[:id])
    authorize @user
  end

end
