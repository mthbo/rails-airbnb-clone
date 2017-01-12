class Message < ApplicationRecord
  belongs_to :user
  belongs_to :deal

  def content_formatted
    "<span>#{self.content.gsub(/\r\n/, '<br>')}</span>"
  end

  def build_first_content
    language_names = self.deal.languages.map { |language| language.name }
    languages_list = "<span class='font-weight-bolder'>Languages accepted:</span> #{language_names.join(', ')}"
    mean_names = self.deal.means.map { |mean| mean.name }
    means_list = "<span class='font-weight-bolder'>Means accepted:</span> #{mean_names.join(', ')}"
    deadline_format = "<span class='font-weight-bolder'>Deadline:</span> #{self.deal.deadline.strftime('%d %b %Y')}"
    "#{self.deal.request} <br> #{languages_list} <br> #{means_list} <br> #{deadline_format}"
  end

end
