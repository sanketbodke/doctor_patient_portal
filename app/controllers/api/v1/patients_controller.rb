# frozen_string_literal: true

module Api
  module V1
    class PatientsController < BaseController
      before_action :set_patient, only: %i[show update destroy]

      # GET /api/v1/patients
      def index
        @patients = Patient.all
        render json: { status: 'success', patients: @patients, count: Patient.count }, status: :ok
      end

      # GET /api/v1/patients/:id
      def show
        render json: { status: 'success', patient: @patient }, status: :ok
      end

      # POST /api/v1/patients
      def create
        @patient = Patient.new(patient_params)

        if @patient.save
          render json: { status: 'success', message: 'Patient created successfully', patient: @patient },
                 status: :created
        else
          render json: { status: 'error', message: @patient.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/patients/:id
      def update
        if @patient.update(patient_params)
          render json: { status: 'success', message: 'Patient updated successfully', patient: @patient }, status: :ok
        else
          render json: { status: 'error', message: @patient.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/patients/:id
      def destroy
        @patient.destroy
        render json: { status: 'success', message: 'Patient deleted successfully' }, status: :ok
      end

      private

      def set_patient
        @patient = Patient.find(params[:id])
      end

      def patient_params
        params.require(:patients).permit(:name, :age, :phone_no, :disease, :doctor_id)
      end
    end
  end
end
