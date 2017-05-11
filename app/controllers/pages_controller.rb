class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :advisor, :about]

  def home
    @search = ""
  end

  def advisor
  end

  def about
  end

end
