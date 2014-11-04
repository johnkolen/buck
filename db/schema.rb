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

ActiveRecord::Schema.define(version: 20141104041018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transfer_id"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "comments", ["transfer_id"], name: "index_comments_on_transfer_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "credentials", force: true do |t|
    t.integer  "user_id"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "temporary",          default: false
    t.datetime "expires_at"
  end

  add_index "credentials", ["encrypted_password"], name: "index_credentials_on_encrypted_password", using: :btree
  add_index "credentials", ["user_id"], name: "index_credentials_on_user_id", using: :btree

  create_table "email_addresses", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "transfers", force: true do |t|
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.integer  "amount_cents"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "on_dashboard",       default: true
    t.integer  "kind",               default: 0
    t.integer  "state",              default: 33
    t.boolean  "flip",               default: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "comment_at"
  end

  add_index "transfers", ["comment_at"], name: "index_transfers_on_comment_at", using: :btree
  add_index "transfers", ["recipient_id"], name: "index_transfers_on_recipient_id", using: :btree
  add_index "transfers", ["user_id"], name: "index_transfers_on_user_id", using: :btree

  create_table "user_friends", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_friends", ["friend_id"], name: "index_user_friends_on_friend_id", using: :btree
  add_index "user_friends", ["user_id"], name: "index_user_friends_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.string   "time_zone",           default: "Central Time (US & Canada)"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree

  create_table "validations", force: true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "validations", ["key"], name: "index_validations_on_key", using: :btree
  add_index "validations", ["user_id"], name: "index_validations_on_user_id", using: :btree

end
