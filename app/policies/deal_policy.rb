class DealPolicy < ApplicationPolicy

  def show?
    record.advisor == user || record.client == user
  end

  def create?
    record.advisor != user && record.offer.active?
  end

  def update?
    record.advisor == user || record.client == user
  end

end
