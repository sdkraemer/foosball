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

ActiveRecord::Schema.define(version: 20150418183158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
  end

  create_table "goals", force: :cascade do |t|
    t.datetime "scored_at"
    t.integer  "game_id"
    t.integer  "team_id"
    t.integer  "position_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",    default: 1
  end

  add_index "goals", ["game_id"], name: "index_goals_on_game_id", using: :btree
  add_index "goals", ["player_id"], name: "index_goals_on_player_id", using: :btree
  add_index "goals", ["position_id"], name: "index_goals_on_position_id", using: :btree
  add_index "goals", ["team_id"], name: "index_goals_on_team_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               limit: 255
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin"
  end

  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true, using: :btree
  add_index "players", ["username"], name: "index_players_on_username", unique: true, using: :btree

  create_table "positions", force: :cascade do |t|
    t.integer  "position_type"
    t.integer  "team_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["player_id"], name: "index_positions_on_player_id", using: :btree
  add_index "positions", ["team_id"], name: "index_positions_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "color"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "winner",     default: false
  end

  add_index "teams", ["game_id"], name: "index_teams_on_game_id", using: :btree

end
