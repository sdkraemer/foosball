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

ActiveRecord::Schema.define(version: 20140927225842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
  end

  create_table "goals", force: true do |t|
    t.datetime "scored_at"
    t.integer  "game_id"
    t.integer  "team_id"
    t.integer  "position_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goals", ["game_id"], name: "index_goals_on_game_id", using: :btree
  add_index "goals", ["player_id"], name: "index_goals_on_player_id", using: :btree
  add_index "goals", ["position_id"], name: "index_goals_on_position_id", using: :btree
  add_index "goals", ["team_id"], name: "index_goals_on_team_id", using: :btree

  create_table "players", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  create_table "positions", force: true do |t|
    t.integer  "position_type"
    t.integer  "team_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["player_id"], name: "index_positions_on_player_id", using: :btree
  add_index "positions", ["team_id"], name: "index_positions_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.integer  "color"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["game_id"], name: "index_teams_on_game_id", using: :btree

end
