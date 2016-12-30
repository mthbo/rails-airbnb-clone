class DealPolicy < ApplicationPolicy

  def show?
    scope.where(:id => record.id).exists? && (record.advisor == user || record.client == user)
  end

  def create?
    record.advisor != user && record.offer.active? && record.offer.deals_ongoing.where(client: user).blank?
  end

  def update?
    record.advisor == user || record.client == user
  end

  def destroy?
    (record.request? && (record.advisor == user || record.client == user)) || (record.proposition? && record.client == user)
  end

end
