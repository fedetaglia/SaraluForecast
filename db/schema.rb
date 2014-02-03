# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140203031854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forecasts", force: true do |t|
    t.string   "location"
    t.datetime "datetime"
    t.float    "lon"
    t.float    "lat"
    t.float    "temperature"
    t.float    "temp_min"
    t.float    "temp_max"
    t.integer  "pressure"
    t.integer  "humidity"
    t.float    "wind_speed"
    t.float    "wind_deg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forecasts_steps", id: false, force: true do |t|
    t.integer "forecast_id"
    t.integer "step_id"
  end

  create_table "steps", force: true do |t|
    t.string   "location"
    t.float    "lon"
    t.float    "lat"
    t.date     "arrival"
    t.integer  "stay"
    t.integer  "trip_id_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["trip_id_id"], name: "index_steps_on_trip_id_id", using: :btree

  create_table "trips", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
