class Zone < ApplicationRecord
  belongs_to :zone_type
  has_many :workspaces, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
end