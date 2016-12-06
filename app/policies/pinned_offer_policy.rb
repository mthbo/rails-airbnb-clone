class PinnedOfferPolicy < ApplicationPolicy

  def show
    false
  end

  def create?
    record.advisor != user
  end

  def destroy?
    record.client == user
  end

end
