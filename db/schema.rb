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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131007125513) do

  create_table "games", :force => true do |t|
    t.integer  "dayNightFreq", :null => false
    t.string   "game_state",   :null => false
    t.float    "kill_radius",  :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "kills", :force => true do |t|
    t.string   "killerID",   :null => false
    t.string   "victimID",   :null => false
    t.float    "lat",        :null => false
    t.float    "lng",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "nickname"
    t.string   "vote_cast"
    t.integer  "game_ID"
    t.integer  "user_id",    :null => false
    t.string   "alignment"
    t.string   "isDead",     :null => false
    t.float    "lat"
    t.float    "lng"
    t.integer  "score"
    t.integer  "votes_for"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reports", :force => true do |t|
    t.string  "high_score"
    t.integer  "game_ID"
    t.string   "winners"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",         :null => false
    t.string   "password_hash", :null => false
    t.string   "password_salt", :null => false
    t.integer  "total_score",   :null => false
    t.integer  "high_score",    :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
