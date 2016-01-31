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

ActiveRecord::Schema.define(version: 20160128074417) do

  create_table "doubles_results", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "team_id",  null: false
    t.integer "win"
    t.integer "loss"
  end

  add_index "doubles_results", ["match_id"], name: "index_doubles_results_on_match_id"
  add_index "doubles_results", ["team_id"], name: "index_doubles_results_on_team_id"

  create_table "match_invites", force: :cascade do |t|
    t.integer  "match_id",   null: false
    t.integer  "user_id",    null: false
    t.string   "side",       null: false
    t.boolean  "accept"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "match_invites", ["match_id"], name: "index_match_invites_on_match_id"
  add_index "match_invites", ["user_id"], name: "index_match_invites_on_user_id"

  create_table "matches", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "category",   null: false
    t.string   "status"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "singles_results", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "user_id",  null: false
    t.string  "side",     null: false
    t.integer "win"
    t.integer "loss"
  end

  add_index "singles_results", ["match_id"], name: "index_singles_results_on_match_id"
  add_index "singles_results", ["user_id"], name: "index_singles_results_on_user_id"

  create_table "teams", force: :cascade do |t|
    t.integer "doubles_result_id"
    t.string  "members"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   null: false
    t.string   "email",      null: false
    t.string   "password",   null: false
    t.string   "img_path"
    t.string   "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
