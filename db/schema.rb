# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_28_184023) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_amenities_on_name", unique: true
  end

  create_table "booking_status_histories", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "status", null: false
    t.datetime "changed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_status_histories_on_booking_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bookings_on_user_id"
    t.index ["workspace_id", "start_time", "end_time"], name: "index_bookings_on_workspace_id_and_start_time_and_end_time"
    t.index ["workspace_id"], name: "index_bookings_on_workspace_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_equipment_on_name", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "user_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "status", default: "pending", null: false
    t.datetime "issued_at", null: false
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_invoices_on_booking_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "booking_id"
    t.text "message", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_notifications_on_booking_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "rate_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "duration_hours", default: 0, null: false
    t.integer "duration_days", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rate_types_on_name", unique: true
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.bigint "rate_type_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rate_type_id"], name: "index_rates_on_rate_type_id"
    t.index ["workspace_id", "rate_type_id"], name: "index_rates_on_workspace_id_and_rate_type_id", unique: true
    t.index ["workspace_id"], name: "index_rates_on_workspace_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "workspace_amenities", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.bigint "amenity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_workspace_amenities_on_amenity_id"
    t.index ["workspace_id", "amenity_id"], name: "idx_workspace_amenities_unique", unique: true
    t.index ["workspace_id"], name: "index_workspace_amenities_on_workspace_id"
  end

  create_table "workspace_equipment", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_workspace_equipment_on_equipment_id"
    t.index ["workspace_id", "equipment_id"], name: "idx_workspace_equipment_unique", unique: true
    t.index ["workspace_id"], name: "index_workspace_equipment_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.bigint "zone_id", null: false
    t.string "name", null: false
    t.string "type", null: false
    t.integer "capacity", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["zone_id", "name"], name: "index_workspaces_on_zone_id_and_name", unique: true
    t.index ["zone_id"], name: "index_workspaces_on_zone_id"
  end

  create_table "zone_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zone_types_on_name", unique: true
  end

  create_table "zones", force: :cascade do |t|
    t.bigint "zone_type_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "capacity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zones_on_name", unique: true
    t.index ["zone_type_id"], name: "index_zones_on_zone_type_id"
  end

  add_foreign_key "booking_status_histories", "bookings"
  add_foreign_key "bookings", "users"
  add_foreign_key "bookings", "workspaces"
  add_foreign_key "invoices", "bookings"
  add_foreign_key "invoices", "users"
  add_foreign_key "notifications", "bookings"
  add_foreign_key "notifications", "users"
  add_foreign_key "rates", "rate_types"
  add_foreign_key "rates", "workspaces"
  add_foreign_key "users", "roles"
  add_foreign_key "workspace_amenities", "amenities"
  add_foreign_key "workspace_amenities", "workspaces"
  add_foreign_key "workspace_equipment", "equipment"
  add_foreign_key "workspace_equipment", "workspaces"
  add_foreign_key "workspaces", "zones"
  add_foreign_key "zones", "zone_types"
end
