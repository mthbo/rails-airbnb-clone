module StatusMessages
  extend ActiveSupport::Concern

  module ClassMethods

    def create_status_message(deal, user)
      @message = deal.messages.new(user: user)
      if deal.proposition?
        @message.content = '.new_proposition'
        @message.target = 'deal_status'
      elsif deal.proposition_declined?
        @message.content = '.proposition_declined'
        @message.target = 'deal_status_alert'
      elsif deal.opened?
        @message.content = '.session_open'
        @message.target = 'deal_status'
      elsif deal.open_expired?
        @message.content = '.session_deadline_passed'
        @message.target = 'deal_status_alert'
      elsif deal.closed?
        @message.content = '.session_closed'
        @message.target = 'deal_status_alert'
      elsif deal.cancelled?
        @message.content = '.session_cancelled'
        @message.target = 'deal_status_alert'
      end
      @message.save
    end

  end

end
