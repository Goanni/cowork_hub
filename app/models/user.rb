class User < ApplicationRecord
  has_secure_password

  belongs_to :role

  has_many :bookings, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true
end