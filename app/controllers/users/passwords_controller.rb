class Users::PasswordsController < Devise::PasswordsController

  def reset
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    password_reset_path if is_navigational_format?
  end

end
