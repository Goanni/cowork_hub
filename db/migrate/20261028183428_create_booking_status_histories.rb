class CreateBookingStatusHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :booking_status_histories do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :status, null: false
      t.datetime :changed_at, null: false

      t.timestamps
    end
  end
end