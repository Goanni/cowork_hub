class CreateRateTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :rate_types do |t|
      t.string :name, null: false
      t.integer :duration_hours, null: false, default: 0
      t.integer :duration_days, null: false, default: 0

      t.timestamps
    end

    add_index :rate_types, :name, unique: true
  end
end