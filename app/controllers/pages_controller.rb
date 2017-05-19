class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :advisor, :about, :terms]

  def home
    @search = ""
  end

  def advisor
  end

  def about
  end

  def terms
  end

end
