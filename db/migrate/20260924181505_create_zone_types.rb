class CreateZoneTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :zone_types do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    add_index :zone_types, :name, unique: true
  end
end