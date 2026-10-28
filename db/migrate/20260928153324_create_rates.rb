class CreateRates < ActiveRecord::Migration[8.1]
  def change
    create_table :rates do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :rate_type, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :rates, [:workspace_id, :rate_type_id], unique: true
  end
end