class MessagePolicy < ApplicationPolicy

  def create?
    true
  end

  def type?
    true
  end
end
