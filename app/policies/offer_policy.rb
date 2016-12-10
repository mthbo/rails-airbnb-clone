class OfferPolicy < ApplicationPolicy

  def show?
    if record.advisor == user
      scope.where(:id => record.id).exists?
    else
      scope.where(:id => record.id).exists? && record.active?
    end
  end

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
