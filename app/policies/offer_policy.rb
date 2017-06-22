class OfferPolicy < ApplicationPolicy

  def new?
    record.advisor == user
  end

  def create?
    record.advisor == user && !user.no_pricing?
  end

  def update?
    record.advisor == user && !record.archived?
  end

  def status?
    record.advisor == user && !record.archived?
  end

  def pin?
    record.advisor != user && !record.archived?
  end

  def remove?
    record.advisor == user && record.deals_ongoing.blank?
  end

  class Scope < Scope
    def resolve
      scope.where.not(status: :archived)
    end
  end
end
