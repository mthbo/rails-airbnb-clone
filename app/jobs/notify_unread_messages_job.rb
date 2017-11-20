class NotifyUnreadMessagesJob < ApplicationJob
  queue_as :default

  def perform()
    User.where(unread_messages: :to_notify).each do |user|
      if user.to_notify?
        UserMailer.unread_messages(user).deliver_later
        user.notified!
      end
    end
  end

end
