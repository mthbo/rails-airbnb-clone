namespace :user do
  desc "Notify all users with unread messages (async)"
  task notify_unread_messages: :environment do
    NotifyUnreadMessagesJob.perform_later
  end
end
