class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_any!
    if admin_signed_in?
      true
    else
      authenticate_user!
    end
  end

  def authenticate_administrator!
    if admin_signed_in?
      true
    elsif user_signed_in?
      redirect_to '/' and return unless current_user.is_admin?
    else
      authenticate_admin!
    end
  end

  private

  def after_sign_in_path_for(resource)
     "/reservations"
  end

end
