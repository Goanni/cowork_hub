class WorkspaceAmenity < ApplicationRecord
  belongs_to :workspace
  belongs_to :amenity

  validates :workspace_id, uniqueness: { scope: :amenity_id }
end