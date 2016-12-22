class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    user == record
  end

  def dashboard?
    user == record
  end

  def destroy?
    user == record
  end
end
