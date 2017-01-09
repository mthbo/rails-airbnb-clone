class ObjectivePolicy < ApplicationPolicy

  def create?
    true
  end

  def update?
    record.deal.advisor == user
  end

  def destroy?
    record.deal.advisor == user
  end
end
