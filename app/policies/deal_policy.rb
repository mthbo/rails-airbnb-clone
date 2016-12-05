class DealPolicy < ApplicationPolicy

  def show?
    record.advisor == user || record.client == user
  end

  def create?
    record.advisor != user
  end

  def update?
    record.advisor == user || record.client == user
  end

  def destroy?
    record.client == user && record.interest?
  end
end