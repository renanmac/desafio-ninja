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

ActiveRecord::Schema.define(version: 2022_01_20_164541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.datetime "start_at", precision: 6
    t.datetime "end_at", precision: 6
    t.string "title"
    t.string "owner_email"
    t.bigint "schedule_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_events_on_room_id"
    t.index ["schedule_id"], name: "index_events_on_schedule_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.bigint "schedule_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["schedule_id"], name: "index_rooms_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "open_time"
    t.string "close_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "events", "rooms"
  add_foreign_key "events", "schedules"
  add_foreign_key "rooms", "schedules"
end
