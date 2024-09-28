# frozen_string_literal: true

module Api
  module V1
    class DoctorsController < BaseController
      before_action :set_doctor, only: [:show_patients]

      # GET /api/v1/doctors/:id/patients
      def show_patients
        if @doctor
          patients = @doctor.patients

          if params[:created_at].present?
            begin
              date = Date.strptime(params[:created_at], '%d-%m-%Y')
              patients = patients.where(created_at: date.beginning_of_day..date.end_of_day)
            rescue ArgumentError
              return render json: {
                status: 'error',
                message: 'Invalid date format. Please use dd-mm-yyyy.'
              }, status: :bad_request
            end
          end

          patient_data = patients.map do |patient|
            {
              id: patient.id,
              name: patient.name,
              age: patient.age,
              phone_no: patient.phone_no,
              disease: patient.disease,
              doctor_id: patient.doctor_id,
              created_at: patient.created_at.strftime('%d-%m-%Y'),
              updated_at: patient.updated_at.strftime('%d-%m-%Y')
            }
          end

          render json: {
            status: 'success',
            doctor: @doctor,
            patients: patient_data
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
