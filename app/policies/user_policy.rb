class UserPolicy < ApplicationPolicy

  def update?
    user == record
  end

  def dashboard?
    user == record
  end

  def welcome?
    user == record
  end

  def destroy?
    user == record && user.deals_ongoing.blank?
  end
end
