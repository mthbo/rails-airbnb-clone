class Message < ApplicationRecord
  belongs_to :user
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  enum target: [ :message, :first_message, :deal_status, :deal_status_alert ]

  after_create_commit :async_message_broadcast

  def build_first_message
    language_flags = self.deal.languages.map{ |language| "<span class='flag-icon-message'>#{language.flag_img}</span>" }.join
    mean_pictos = self.deal.means.map { |mean| "<span class='mean-icon-message'>#{mean.picto_i}</span>" }.join
    self.content = "#{self.deal.request} <br> #{language_flags} &nbsp;&nbsp; #{mean_pictos}"
    self.target = 'first_message'
  end

  def build_deal_status_message
    if self.deal.proposition?
      self.content = '.new_proposition'
      self.target = 'deal_status'
    elsif self.deal.proposition_declined?
      self.content = '.proposition_declined'
      self.target = 'deal_status_alert'
    elsif self.deal.opened?
      self.content = '.session_open'
      self.target = 'deal_status'
    elsif self.deal.open_expired?
      self.content = '.session_deadline_passed'
      self.target = 'deal_status_alert'
    elsif self.deal.closed?
      self.content = '.session_closed'
      self.target = 'deal_status_alert'
    elsif self.deal.cancelled?
      self.content = '.session_cancelled'
      self.target = 'deal_status_alert'
    end
  end

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
