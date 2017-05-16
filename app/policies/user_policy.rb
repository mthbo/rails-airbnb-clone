class UserPolicy < ApplicationPolicy

  def update?
    user == record
  end

  def dashboard?
    user == record
  end

  def country?
    user == record
  end

  def update_country?
    user == record
  end

  def stripe_connection?
    user == record
  end

  def change_locale?
    user == record
  end

  def destroy?
    user == record && user.deals_ongoing.blank?
  end
end
