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

ActiveRecord::Schema.define(version: 20161022224142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "data_transfers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "origin_row",                              null: false
    t.integer  "origin_col",                              null: false
    t.integer  "destination_row",                         null: false
    t.integer  "destination_col",                         null: false
    t.integer  "origin_worksheet_index",      default: 0, null: false
    t.integer  "destination_worksheet_index",             null: false
    t.uuid     "origin_file_id"
    t.uuid     "destination_file_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "destination_files", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "position"
    t.string   "path"
    t.uuid     "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position", "task_id"], name: "index_destination_files_on_position_and_task_id", unique: true, using: :btree
  end

  create_table "origin_files", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "position"
    t.uuid     "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position", "task_id"], name: "index_origin_files_on_position_and_task_id", unique: true, using: :btree
  end

  create_table "tasks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.uuid     "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "data_transfers", "destination_files"
  add_foreign_key "data_transfers", "origin_files"
  add_foreign_key "destination_files", "tasks"
  add_foreign_key "origin_files", "tasks"
  add_foreign_key "tasks", "users"
end
