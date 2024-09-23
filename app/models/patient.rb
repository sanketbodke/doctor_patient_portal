# frozen_string_literal: true

class Patient < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
end
