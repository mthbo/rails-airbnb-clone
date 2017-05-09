class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :advisor]

  def home
    @search = ""
  end

  def advisor
  end

end
