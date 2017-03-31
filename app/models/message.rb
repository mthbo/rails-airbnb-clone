class Message < ApplicationRecord
  belongs_to :user
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  enum target: [ :message, :deal_status ]

  after_create_commit :async_message_broadcast

  def build_first_content
    deadline_format = "<span class='message-deadline'><span class='info-icon'>#{ActionController::Base.helpers.image_tag('date.svg')}</span><span class='font-weight-normal'>#{I18n.l(self.deal.deadline.to_date, format: :default)}</span></span>"
    language_flags = self.deal.languages.map{ |language| "<span class='flag-icon-message'>#{language.flag_img}</span>" }.join
    mean_pictos = self.deal.means.map { |mean| "<span class='mean-icon-message'>#{mean.picto_i}</span>" }.join
    self.content = "#{deadline_format} #{self.deal.request} <br> #{language_flags} <br> #{mean_pictos}"
  end

  def build_deal_status_content
    if self.deal.proposition?
      self.content = "<span class='font-weight-normal blue'>#{I18n.t('message.new_proposition')}</span>"
    elsif self.deal.proposition_declined?
      self.content = "<span class='font-weight-normal blue'>#{I18n.t('message.proposition_declined')}</span>"
    elsif self.deal.open?
      self.content = "<span class='font-weight-normal blue'>#{I18n.t('message.session_open')}</span>"
    elsif self.deal.open_expired?
      self.content = "<span class='font-weight-normal blue'>#{I18n.t('message.session_deadline_passed')}</span>"
    elsif self.deal.closed?
      self.content = "<span class='font-weight-normal red'>#{I18n.t('message.session_closed')}</span>"
    elsif self.deal.cancelled?
      self.content = "<span class='font-weight-normal red'>#{I18n.t('message.session_cancelled')}</span>"
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
