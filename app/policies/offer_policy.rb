class OfferPolicy < ApplicationPolicy

  def create?
    record.advisor == user
  end

  def update?
    record.advisor == user
  end

  def destroy?
    record.advisor == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end