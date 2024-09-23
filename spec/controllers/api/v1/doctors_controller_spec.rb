# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DoctorsController, type: :controller do
  # Create a doctor user and patients associated with the doctor
  let!(:doctor) { create(:user, role: 'doctor') }
  let!(:patients) { create_list(:user, 3, role: 'patient', doctor:) }

  describe 'GET #show_patients' do
    context 'when doctor exists' do
      before do
        get :show_patients, params: { id: doctor.id }
      end

      it 'returns a success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the doctor details' do
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['doctor']['id']).to eq(doctor.id)
      end

      it 'returns associated patients' do
        json_response = JSON.parse(response.body)
        expect(json_response['patients'].size).to eq(3)
      end
    end

    context 'when doctor does not exist' do
      before do
        get :show_patients, params: { id: 999 }
      end

      it 'returns a not found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Doctor not found')
      end
    end
  end
end
