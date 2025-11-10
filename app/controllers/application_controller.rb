class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  before_action :touch_session_expiry

  SESSION_TIMEOUT = 30.minutes # inactivity timeout

  private

  def current_user
    return @current_user if defined?(@current_user)
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    current_user.present?
  end

  # require login for controllers that need it
  def authenticate_user!
    unless logged_in?
      redirect_to login_path, alert: "Please log in"
    end
  end

  # Sliding session expiry: extend on activity
  def touch_session_expiry
    return unless session[:last_seen_at]
    if Time.current > session[:last_seen_at] + SESSION_TIMEOUT
      reset_session
    else
      # update last seen to implement sliding expiration
      session[:last_seen_at] = Time.current
    end
  end
end
