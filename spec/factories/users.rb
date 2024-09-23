# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :doctor do
      role { 'doctor' }
    end

    trait :patient do
      role { 'patient' }
      association :doctor, factory: :user, role: 'doctor' # A patient is associated with a doctor
    end
  end
end
