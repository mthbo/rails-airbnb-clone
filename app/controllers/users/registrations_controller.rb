class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def after_update_path_for(resource)
    if resource.is_a?(User)
      user_path(resource)
    else
      super
    end
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end
