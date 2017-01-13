class Message < ApplicationRecord
  belongs_to :user
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  after_create_commit { MessageBroadcastJob.perform_now self }

  def content_formatted
    "<p>#{self.content.gsub(/\r\n/, '<br>')}</p>"
  end

  def build_first_content
    language_names = self.deal.languages.map { |language| language.name }
    languages_list = "<span class='font-weight-bolder'>Languages accepted:</span> #{language_names.join(', ')}"
    mean_names = self.deal.means.map { |mean| mean.name }
    means_list = "<span class='font-weight-bolder'>Means accepted:</span> #{mean_names.join(', ')}"
    deadline_format = "<span class='font-weight-bolder'>Deadline:</span> #{self.deal.deadline.strftime('%d %b %Y')}"
    self.content = "#{self.deal.request} <br> #{languages_list} <br> #{means_list} <br> #{deadline_format}"
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
