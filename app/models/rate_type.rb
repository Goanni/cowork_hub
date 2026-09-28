class RateType < ApplicationRecord
  has_many :rates, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :duration_hours, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_days, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :at_least_one_duration

  private

  def at_least_one_duration
    if duration_hours.to_i <= 0 && duration_days.to_i <= 0
      errors.add(:base, "Должна быть указана длительность хотя бы в часах или днях")
    end
  end
end