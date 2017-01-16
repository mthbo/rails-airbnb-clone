class Message < ApplicationRecord
  belongs_to :user
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  enum target: [ :message, :deal_status ]

  after_create_commit { MessageBroadcastJob.perform_now self }

  def build_first_content
    language_names = self.deal.languages.map { |language| language.name }
    languages_list = "<span class='font-weight-bolder'>Languages accepted:</span> #{language_names.join(', ')}"
    mean_names = self.deal.means.map { |mean| mean.name }
    means_list = "<span class='font-weight-bolder'>Means accepted:</span> #{mean_names.join(', ')}"
    deadline_format = "<span class='font-weight-bolder'>Deadline:</span> #{self.deal.deadline.strftime('%d %b %Y')}"
    self.content = "#{self.deal.request} <br> #{languages_list} <br> #{means_list} <br> #{deadline_format}"
  end

  def build_deal_status_content
    if self.deal.proposition?
      self.content = "<span class='font-weight-normal blue'>New proposition </span>"
    elsif self.deal.proposition_declined?
      self.content = "<span class='font-weight-normal blue'>Proposition declined</span>"
    elsif self.deal.open?
      self.content = "<span class='font-weight-normal blue'>Session open</span>"
    elsif self.deal.closed?
      self.content = "<span class='font-weight-normal red'>Session closed</span>"
    elsif self.deal.cancelled?
      self.content = "<span class='font-weight-normal red'>Session cancelled</span>"
    end
  end

  def date_formatted
    if created_at.year < Date.today.year
      created_at.strftime('%d %b %Y')
    elsif created_at < Date.today - 6
      created_at.strftime('%d %b')
    elsif created_at < Date.today
      created_at.strftime('%A')
    else
      created_at.strftime('%H:%M')
    end
  end

end
