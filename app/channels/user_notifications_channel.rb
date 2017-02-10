class UserNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{current_user.id}:notifications"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
