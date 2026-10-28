class Invoice < ApplicationRecord
  belongs_to :booking
  belongs_to :user

  STATUSES = %w[pending paid cancelled].freeze

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :issued_at, presence: true
end