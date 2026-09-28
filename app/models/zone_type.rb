class ZoneType < ApplicationRecord
  has_many :zones, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end