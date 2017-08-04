class UserPolicy < ApplicationPolicy

  def welcome?
    user == record
  end

  def dashboard?
    user == record
  end

  def country?
    user == record
  end

  def update_country?
    country?
  end

  def details?
    user == record && !user.no_pricing? && !user.verified? && (user.disabled_reason_category != 'rejected')
  end

  def update?
    details?
  end

  def bank?
    user == record && !user.no_pricing? && !user.pricing_pending? && (user.disabled_reason_category != 'rejected')
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
