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

ActiveRecord::Schema.define(version: 20151231023927) do

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "recipient_id"
    t.integer  "actor_id"
    t.boolean  "unread",          default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.boolean  "solved",          default: false
    t.integer  "n_type",          default: 0
    t.index ["notifiable_id", "notifiable_type"], name: "index_notifications_on_notifiable_id_and_notifiable_type"
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "owner_id"
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
  end

  create_table "rooms_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
