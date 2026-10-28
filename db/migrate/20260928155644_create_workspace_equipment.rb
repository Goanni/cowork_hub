class CreateWorkspaceEquipment < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_equipment do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true

      t.timestamps
    end

    add_index :workspace_equipment,
              [:workspace_id, :equipment_id],
              unique: true,
              name: "idx_workspace_equipment_unique"
  end
end