class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create] # for JSON/curl; keep CSRF for forms

  def new
    # renders login form
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)
    if user&.authenticate(params[:password])
      # Important: reset_session to prevent session fixation
      reset_session

      # set session
      session[:user_id] = user.id
      session[:last_seen_at] = Time.current
      # optionally set a persistent "remember me" cookie
      if params[:remember_me] == "1"
        cookies.signed[:remember_user_id] = { value: user.id, expires: 14.days.from_now, httponly: true, secure: Rails.env.production? }
      end

      redirect_to home_path, notice: "Logged in"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unauthorized
    end
  end

  def destroy
    # Server-side invalidate: reset_session clears session and issues a new session id
    reset_session
    cookies.delete(:remember_user_id)
    redirect_to login_path, notice: "Logged out"
  end
end
