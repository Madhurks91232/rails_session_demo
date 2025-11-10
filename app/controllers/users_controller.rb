class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log in the user immediately
      reset_session  # prevent session fixation
      session[:user_id] = @user.id
      session[:last_seen_at] = Time.current
      redirect_to root_path, notice: "Signup successful! Logged in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # strong params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
