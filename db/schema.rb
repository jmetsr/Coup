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

ActiveRecord::Schema.define(version: 20150622214733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.boolean  "is_in_deck"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card_type"
    t.boolean  "is_dead"
  end

  add_index "cards", ["game_id"], name: "index_cards_on_game_id", using: :btree

  create_table "game_proposals", force: true do |t|
    t.integer  "proposer_id"
    t.integer  "proposed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "games", force: true do |t|
    t.integer  "current_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_of_players"
    t.text     "log"
    t.integer  "active_player_id"
    t.boolean  "is_delt"
    t.boolean  "is_built"
    t.text     "chat"
  end

  create_table "users", force: true do |t|
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_token"
    t.integer  "time_out_time"
    t.boolean  "accepted"
    t.boolean  "rejected"
    t.integer  "money"
    t.integer  "game_id"
    t.boolean  "is_blocking"
    t.boolean  "is_allowing"
    t.boolean  "is_active"
    t.boolean  "is_bot"
  end

end
