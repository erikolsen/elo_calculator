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

ActiveRecord::Schema.define(version: 20150712224410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "facebook_accounts", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.string   "image_url"
    t.string   "email"
    t.datetime "oauth_expires_at"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "winner_rating"
    t.integer  "loser_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
    t.integer  "loser_id"
  end

  add_index "games", ["loser_id"], name: "index_games_on_loser_id", using: :btree
  add_index "games", ["winner_id"], name: "index_games_on_winner_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "rating",                 default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["name"], name: "index_players_on_name", using: :btree
  add_index "players", ["rating"], name: "index_players_on_rating", using: :btree

end
