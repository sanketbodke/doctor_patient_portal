# frozen_string_literal: true

module Api
  module V1
    class DoctorsController < BaseController
      before_action :set_doctor, only: [:show_patients]

      # GET /api/v1/doctors/:id/patients
      def show_patients
        if @doctor
          patients = @doctor.patients
          render json: {
            status: 'success',
            doctor: @doctor,
            patients:
          }, status: :ok
        else
          render json: {
            status: 'error',
            message: 'Doctor not found'
          }, status: :not_found
        end
      end

      private

      def set_doctor
        @doctor = User.find_by(id: params[:id], role: 'doctor')
      end
    end
  end
end
