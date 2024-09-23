# frozen_string_literal: true

# spec/requests/api/v1/sessions_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let!(:user) { create(:user, username: 'testuser', password: 'password123') }

  describe 'POST /api/v1/users/sign_in' do
    context 'with valid credentials' do
      before do
        post '/api/v1/users/sign_in', params: { username: 'testuser', password: 'password123' }
      end

      it 'returns a success message' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['message']).to eq('Logged in successfully.')
        expect(json['token']).to be_present
      end
    end

    context 'with invalid password' do
      before do
        post '/api/v1/users/sign_in', params: { username: 'testuser', password: 'wrongpassword' }
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('error')
        expect(json['message']).to eq('Invalid email or password.')
      end
    end

    context 'with non-existent username' do
      before do
        post '/api/v1/users/sign_in', params: { username: 'nonexistentuser', password: 'password123' }
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('error')
        expect(json['message']).to eq('Invalid email or password.')
      end
    end
  end
end
