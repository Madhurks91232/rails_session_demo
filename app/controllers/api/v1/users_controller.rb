module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_jwt!

      def profile
        render json: { id: current_user.id, email: current_user.email }
      end

      private

      def authenticate_jwt!
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        begin
          decoded = JWT.decode(token, JWT_SECRET, true, { algorithm: 'HS256' })
          @current_user = User.find(decoded[0]['user_id'])
        rescue JWT::ExpiredSignature
          render json: { error: 'Token expired' }, status: :unauthorized
        rescue JWT::DecodeError
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      end

      def current_user
        @current_user
      end
    end
  end
end
