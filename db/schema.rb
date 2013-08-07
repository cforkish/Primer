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

ActiveRecord::Schema.define(version: 20130719033031) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "content_nodes", id: :uuid, force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependencies", id: :uuid, force: true do |t|
    t.uuid     "enable_id"
    t.uuid     "need_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evaluators", id: :uuid, force: true do |t|
    t.uuid     "content_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lessons", id: :uuid, force: true do |t|
    t.string   "name"
    t.uuid     "content_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "node_friendships", id: :uuid, force: true do |t|
    t.uuid     "structure_node_id"
    t.uuid     "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "structure_content", id: :uuid, force: true do |t|
    t.uuid     "parent_structure_node_id"
    t.uuid     "child_content_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "structure_nodes", id: :uuid, force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "structure_parent_child", id: :uuid, force: true do |t|
    t.uuid     "parent_id"
    t.uuid     "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :uuid, force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "username"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
