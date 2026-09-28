class CreateWorkspaces < ActiveRecord::Migration[8.1]
  def change
    create_table :workspaces do |t|
      t.references :zone, null: false, foreign_key: true
      t.string :name, null: false
      t.string :type, null: false
      t.integer :capacity, null: false
      t.text :description

      t.timestamps
    end

    add_index :workspaces, [:zone_id, :name], unique: true
  end
end