class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :advisor, :about, :terms]
  layout 'client_form', only: [:contact]

  def home
    @search = ""
    @offer_sample = Offer.sample(3)
  end

  def advisor
  end

  def about
  end

  def terms
  end

end
