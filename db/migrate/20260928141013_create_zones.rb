class CreateZones < ActiveRecord::Migration[8.1]
  def change
    create_table :zones do |t|
      t.references :zone_type, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :capacity, null: false

      t.timestamps
    end

    add_index :zones, :name, unique: true
  end
end