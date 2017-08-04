class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.find_for_facebook_oauth(request.env['omniauth.auth'])

    if user.persisted?
      if user.first_time?
        sign_in(user)
        redirect_to welcome_path
      else
        sign_in_and_redirect user, event: :authentication
      end
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end

  end

end
