class Equipment < ApplicationRecord
  self.table_name = "equipment"

  has_many :workspace_equipment, dependent: :destroy
  has_many :workspaces, through: :workspace_equipment

  validates :name, presence: true, uniqueness: true
end