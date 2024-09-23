# frozen_string_literal: true

# spec/controllers/api/v1/registrations_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe 'POST #create' do
    let(:valid_attributes) do
      {
        username: 'testuser',
        email: 'testuser@example.com',
        password: 'password',
        password_confirmation: 'password',
        role: 'doctor'
      }
    end

    let(:invalid_attributes) do
      {
        username: '',
        email: 'invalidemail.com',
        password: 'password',
        password_confirmation: 'different_password',
        role: 'doctor'
      }
    end

    context 'when the request is valid' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'returns a success status' do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it 'returns a success message' do
        post :create, params: { user: valid_attributes }
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('User created successfully.')
      end
    end

    context 'when the request is invalid' do
      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post :create, params: { user: invalid_attributes }
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to include("Username can't be blank")
      end
    end
  end
end
