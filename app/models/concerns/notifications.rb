module Notifications
  extend ActiveSupport::Concern

  def increment_notifications(user)
    if user == self.client
      self.client_notifications += 1
    elsif user == self.advisor
      self.advisor_notifications += 1
    end
  end

  def reset_notifications(user)
    if user == self.client
      self.client_notifications = 0
    elsif user == self.advisor
      self.advisor_notifications = 0
    end
  end
end
