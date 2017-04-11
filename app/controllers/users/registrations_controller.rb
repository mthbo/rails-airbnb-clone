class Users::RegistrationsController < Devise::RegistrationsController
  before_action :remove_offers_from_index, only: [:destroy]
  after_action :index_offers, only: [:update]

  def index_offers
    resource.offers.each { |offer| offer.index! }
  end

  def remove_offers_from_index
    resource.offers.each { |offer| offer.remove_from_index! }
  end

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

end
