class ObjectivePolicy < ApplicationPolicy

  def create?
    record.deal.advisor == user && (record.deal.request? || record.deal.proposition_declined?)
  end

  def update?
    record.deal.advisor == user
  end

  def destroy?
    record.deal.advisor == user
  end
end
