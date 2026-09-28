class Workspace < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :zone

  has_many :rates, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :workspace_amenities, dependent: :destroy
  has_many :amenities, through: :workspace_amenities
  has_many :workspace_equipment, dependent: :destroy
  has_many :equipment, through: :workspace_equipment

  validates :name, presence: true, uniqueness: { scope: :zone_id }
  validates :type, presence: true, inclusion: { in: %w[desk meeting_room conference_room] }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
end