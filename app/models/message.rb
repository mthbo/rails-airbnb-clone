class Message < ApplicationRecord
  include StatusMessages

  belongs_to :user
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  enum target: [ :message, :deal_status, :deal_status_alert ]

  after_create_commit :async_message_broadcast

  def date_formatted
    if created_at.year < DateTime.current.in_time_zone.year
      I18n.l(created_at.to_date, format: :long)
    elsif created_at < 6.days.ago.beginning_of_day
      I18n.l(created_at.to_date, format: :short)
    elsif created_at < DateTime.current.in_time_zone.beginning_of_day
      I18n.l(created_at.to_date, format: "%A")
    else
      I18n.l(created_at, format: "%H:%M")
    end
  end

  private

  def async_message_broadcast
    MessageBroadcastJob.perform_later(self) unless self.deal.messages.count <= 1
  end

end
