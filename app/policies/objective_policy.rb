class ObjectivePolicy < ApplicationPolicy

  def create?
    record.deal.advisor == user && (record.deal.request? || record.deal.proposition_declined?)
  end

  def update?
    record.deal.client == user && record.deal.closed?
  end

  def destroy?
    record.create?
  end
end
