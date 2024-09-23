# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true
  validates :email, presence: true
  validates :role, presence: true, inclusion: { in: %w[receptionist doctor] }

  has_many :patients, foreign_key: 'doctor_id', dependent: :destroy

  def doctor?
    role == 'doctor'
  end
end
