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

ActiveRecord::Schema.define(version: 20161006030437) do

  create_table "compare_nouns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "noun",       null: false
    t.integer  "point",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["noun"], name: "index_compare_nouns_on_noun", using: :btree
  end

  create_table "compare_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "twitter_id", null: false
    t.datetime "last_tweet"
    t.integer  "weight",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uid",        null: false
    t.string   "twitter_id", null: false
    t.string   "image_url"
    t.integer  "point"
    t.string   "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  end

end
