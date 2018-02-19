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

ActiveRecord::Schema.define(version: 20180211180910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brackets", force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "matchup_id"
    t.boolean "bye", default: false
    t.string "bracket_type"
    t.integer "winner_child"
    t.integer "loser_child"
    t.integer "tournament_sequence"
    t.integer "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bracket_type"], name: "index_brackets_on_bracket_type"
    t.index ["matchup_id"], name: "index_brackets_on_matchup_id"
    t.index ["tournament_id"], name: "index_brackets_on_tournament_id"
    t.index ["tournament_sequence"], name: "index_brackets_on_tournament_sequence"
  end

  create_table "clubs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_clubs_on_slug"
  end

  create_table "entries", id: :serial, force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_entries_on_player_id"
    t.index ["tournament_id"], name: "index_entries_on_tournament_id"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.integer "winner_rating"
    t.integer "loser_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "winner_id"
    t.integer "loser_id"
    t.integer "matchup_id"
    t.index ["loser_id"], name: "index_games_on_loser_id"
    t.index ["matchup_id"], name: "index_games_on_matchup_id"
    t.index ["winner_id"], name: "index_games_on_winner_id"
  end

  create_table "matchups", id: :serial, force: :cascade do |t|
    t.integer "primary_id"
    t.integer "secondary_id"
    t.integer "winner_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "series_max"
    t.index ["tournament_id"], name: "index_matchups_on_tournament_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_memberships_on_club_id"
    t.index ["player_id"], name: "index_memberships_on_player_id"
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "rating", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_players_on_name"
    t.index ["rating"], name: "index_players_on_rating"
  end

  create_table "tournaments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "end_date"
    t.string "type"
    t.integer "series_max"
    t.index ["type"], name: "index_tournaments_on_type"
  end

  add_foreign_key "brackets", "matchups"
  add_foreign_key "brackets", "tournaments"
  add_foreign_key "memberships", "clubs"
  add_foreign_key "memberships", "players"
end
