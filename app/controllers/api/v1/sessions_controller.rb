module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token

      # POST /api/v1/login
      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = generate_jwt(user)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      private

      def generate_jwt(user)
        payload = {
          user_id: user.id,
          exp: 1.hour.from_now.to_i  # token expires in 1 hour
        }
        JWT.encode(payload, JWT_SECRET, 'HS256')
      end
    end
  end
end
