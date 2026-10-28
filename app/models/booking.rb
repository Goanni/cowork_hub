class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  has_many :invoices, dependent: :destroy
  has_many :booking_status_histories, dependent: :destroy
  has_many :notifications, dependent: :destroy

  STATUSES = %w[pending confirmed cancelled completed].freeze

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    if end_time <= start_time
      errors.add(:end_time, "должно быть позже start_time")
    end
  end
end