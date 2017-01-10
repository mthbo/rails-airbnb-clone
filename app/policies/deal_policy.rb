class DealPolicy < ApplicationPolicy

  def show?
    scope.where(:id => record.id).exists? && (record.advisor == user || record.client == user)
  end

  def create?
    record.advisor != user && record.offer.active? && record.offer.ongoing_deal(user).blank?
  end

  def update?
    record.advisor == user || record.client == user
  end

  def proposition?
    record.advisor == user && (record.request? || record.proposition_declined?)
  end

  def open_or_decline?
    record.client == user && record.proposition?
  end

  def close?
    (record.client == user && (record.open? || record.open_expired?)) || (record.advisor == user && record.open_expired?)
  end

  def cancel?
    ((record.request? || record.proposition_declined?) && (record.advisor == user || record.client == user))
  end

end
