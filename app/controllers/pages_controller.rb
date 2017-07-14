class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :advisor, :about, :terms, :privacy]
  layout 'client_form', only: [:contact]

  def home
    @search = ""
    @offer_sample = Offer.sample(3)
  end

  def advisor
    @offer = Offer.first
  end

  def about
  end

  def terms
  end

  def privacy
  end

end
