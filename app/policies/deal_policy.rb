class DealPolicy < ApplicationPolicy

  def show?
    scope.where(:id => record.id).exists? && (record.advisor == user || record.client == user)
  end

  def create?
    record.advisor != user && record.offer.active? && record.offer.ongoing_deal(user).blank?
  end

  def new?
    create? || (user == nil && record.offer.active?)
  end

  def new_proposition?
    record.advisor == user && (record.request? || record.proposition_declined?)
  end

  def save_proposition?
    new_proposition?
  end

  def submit_proposition?
    new_proposition?
  end

  def decline_proposition?
    record.client == user && record.proposition?
  end

  def open_session?
    record.client == user && record.proposition?
  end

  def close_session?
    (record.client == user && (record.opened? || record.open_expired?)) || (record.advisor == user && record.open_expired?)
  end

  def new_review?
    record.closed? && ((user == record.advisor && record.client && !record.reviewed_by_advisor?) || (user == record.client && record.advisor && !record.reviewed_by_client?))
  end

  def save_review?
    new_review?
  end

  def disable_messages?
    (record.messages_disabled == false) && record.closed? && ((user == record.advisor && record.advisor_review_at.present?) || (user == record.client && record.client_review_at.present?))
  end

  def cancel_session?
    ((record.request? || record.proposition_declined?) && (record.advisor == user || record.client == user))
  end

end
