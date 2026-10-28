class BookingStatusHistory < ApplicationRecord
  belongs_to :booking

  validates :status, presence: true
  validates :changed_at, presence: true
end