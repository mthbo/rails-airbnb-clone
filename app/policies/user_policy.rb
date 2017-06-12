class UserPolicy < ApplicationPolicy

  def dashboard?
    user == record
  end

  def country?
    user == record
  end

  def update_country?
    country?
  end

  def stripe_connection?
    user == record
  end

  def details?
    user == record && !user.no_pricing? && !user.verified?
  end

  def update?
    details?
  end

  def bank?
    user == record && !user.no_pricing? && !user.pricing_pending?
  end

  def update_bank?
    bank?
  end

  def change_locale?
    user == record
  end

  def destroy?
    user == record && user.deals_ongoing.blank?
  end
end
