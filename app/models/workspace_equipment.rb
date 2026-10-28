class WorkspaceEquipment < ApplicationRecord
  self.table_name = "workspace_equipment"

  belongs_to :workspace
  belongs_to :equipment

  validates :workspace_id, uniqueness: { scope: :equipment_id }
end