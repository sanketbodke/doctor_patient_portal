# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'creates a user with FactoryBot' do
    user = create(:user)
    expect(user).to be_valid
  end
end
