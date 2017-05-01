module Receiver
  extend ActiveSupport::Concern

  def set_receiver
    if current_user == @deal.client
      @receiver = @deal.advisor
    elsif current_user == @deal.advisor
      @receiver = @deal.client
    end
  end
end
