class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def dashboard?
    user == record
  end
end
