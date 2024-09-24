# frozen_string_literal: true

module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_request, only: [:create]

      # POST /api/v1/users/sign_in

      def create
        user = User.find_by(username: params[:username])
        if user&.valid_password?(params[:password])
          token = JwtHelper.encode(user_id: user.id)
          render json: { status: 'success', message: 'Logged in successfully.', user:, token: }, status: :ok
        else
          render json: { status: 'error', message: 'Invalid email or password.' }, status: :unauthorized
        end
      end
    end
  end
end
