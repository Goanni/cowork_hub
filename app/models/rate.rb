class Rate < ApplicationRecord
  belongs_to :workspace
  belongs_to :rate_type

  validates :price, presence: true, numericality: { greater_than: 0 }
end