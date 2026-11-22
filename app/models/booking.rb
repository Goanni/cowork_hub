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
  validate :start_time_cannot_be_in_the_past
  validate :within_working_hours

  attr_accessor :rate_id

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    if end_time <= start_time
      errors.add(:end_time, "должно быть позже времени начала")
    end
  end

  def start_time_cannot_be_in_the_past
    return if start_time.blank?
    if start_time < Time.current
      errors.add(:start_time, "не может быть в прошлом")
    end
  end

  def within_working_hours
    return if start_time.blank? || end_time.blank?

    work_start = Workspace::WORK_START_HOUR
    work_end = Workspace::WORK_END_HOUR

    start_h = start_time.in_time_zone.hour
    end_h = end_time.in_time_zone.hour
    end_m = end_time.in_time_zone.min

    if start_h < work_start || start_h >= work_end
      errors.add(:base, "Начало брони должно быть в рабочие часы (с #{work_start}:00 до #{work_end}:00)")
    end

    if end_h > work_end || (end_h == work_end && end_m > 0)
      errors.add(:base, "Конец брони должен быть не позже #{work_end}:00")
    end
  end
end