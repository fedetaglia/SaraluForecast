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

ActiveRecord::Schema.define(version: 20140204011407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forecasts", force: true do |t|
    t.string   "location"
    t.string   "country"
    t.float    "lon"
    t.float    "lat"
    t.datetime "day"
    t.string   "weather"
    t.string   "description"
    t.float    "temp_mor"
    t.float    "temp_day"
    t.float    "temp_eve"
    t.float    "temp_nig"
    t.float    "pressure"
    t.integer  "humidity"
    t.float    "speed"
    t.integer  "deg"
    t.integer  "clouds"
    t.integer  "rain"
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
    t.date     "arrive_on"
    t.integer  "stay"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["trip_id"], name: "index_steps_on_trip_id", using: :btree

  create_table "trips", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
