class Users::RegistrationsController < Devise::RegistrationsController
  after_action :index_offers, only: [:update]
  before_action :remove_offers_from_index, only: [:destroy]
  before_action :disable_all_deal_messages, only: [:destroy]


  def confirm
  end

  protected

  def after_update_path_for(resource)
    if resource.is_a?(User)
      user_path(resource)
    else
      super
    end
  end

  def after_inactive_sign_up_path_for(resource)
    users_confirm_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end


  private

  def index_offers
    resource.offers.each { |offer| offer.index! }
  end

  def remove_offers_from_index
    resource.offers.each { |offer| offer.remove_from_index! }
  end

  def disable_all_deal_messages
    resource.deals_closed.each do |deal|
      deal.messages_disabled = true
      if resource == deal.client
        receiver = deal.advisor
        deal.advisor_notifications += 1
      elsif resource == deal.advisor
        receiver = deal.client
        deal.client_notifications += 1
      end
      deal.save
      DisableMessagesBroadcastJob.perform_later(deal, receiver)
      DealCardsBroadcastJob.perform_later(deal)
    end
  end

end
