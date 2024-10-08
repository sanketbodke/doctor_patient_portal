# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < ApplicationController
      # POST /api/v1/users

      def create
        user = User.new(user_params)
        if user.save
          render json: { status: 'success', message: 'User created successfully.' }, status: :created
        else
          render json: { status: 'error', message: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
      end
    end
  end
end
