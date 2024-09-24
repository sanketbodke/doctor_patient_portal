# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: %i[show update destroy]

      # GET /api/v1/users
      def index
        @users = if params[:role].present?
                   User.where(role: params[:role])
                 else
                   User.all
                 end

        role_counts = User.group(:role).count
        total_users_count = User.count

        render json: {
          status: 'success',
          users: @users,
          role_counts:,
          total_users_count:
        }, status: :ok
      end

      # GET /api/v1/users/:id
      def show
        render json: { status: 'success', user: @user }, status: :ok
      end

      # PATCH/PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render json: { status: 'success', message: 'User updated successfully', user: @user }, status: :ok
        else
          render json: { status: 'error', message: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        render json: { status: 'success', message: 'User deleted successfully' }, status: :ok
      end

      def update_password
        otp_code = generate_otp_code
        @current_user.update(otp_code:, otp_generated_at: Time.current)
        UserMailer.otp(@current_user, otp_code).deliver_now
        render json: { message: 'OTP has been sent to your email.' }, status: :ok
      end

      def verify_otp
        if params[:otp_code] == @current_user.otp_code && otp_not_expired?(@current_user)
          user_service = UserService.new(@current_user)
          result = user_service.update_password(params[:current_password], params[:new_password],
                                                params[:password_confirmation])

          if result == 'Password updated successfully'
            @current_user.update(otp_code: nil, otp_generated_at: nil)
            render json: { message: result }, status: :ok
          else
            render json: { error: result }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Invalid or expired OTP' }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { status: 'error', message: 'User not found' }, status: :not_found
      end

      def generate_otp_code
        rand(1000..9999)
      end

      def otp_not_expired?(user)
        user.otp_generated_at && user.otp_generated_at > 10.minutes.ago
      end

      def user_params
        params.require(:users).permit(:username, :email, :password, :password_confirmation, :role)
      end
    end
  end
end
