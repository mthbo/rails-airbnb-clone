class OfferPolicy < ApplicationPolicy

  def create?
    record.advisor == user
  end

  def update?
    record.advisor == user
  end

  def destroy?
    record.advisor == user && record.deals_ongoing.blank?
  end

  class Scope < Scope
    def resolve
      scope.where.not(status: :archived)
    end
  end
end
