class CreateWorkspaceAmenities < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_amenities do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :amenity, null: false, foreign_key: true

      t.timestamps
    end

    add_index :workspace_amenities,
              [:workspace_id, :amenity_id],
              unique: true,
              name: "idx_workspace_amenities_unique"
  end
end