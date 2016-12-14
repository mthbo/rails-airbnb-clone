class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :be_advisor]

  def home
    @search = ""
  end

  def be_advisor
  end

end
