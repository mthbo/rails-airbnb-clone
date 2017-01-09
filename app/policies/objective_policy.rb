class ObjectivePolicy < ApplicationPolicy

  def create?
    record.deal.advisor == user && (record.deal.request? || record.deal.proposition_declined?)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

end
