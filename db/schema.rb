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

ActiveRecord::Schema.define(version: 2021_01_26_205223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "title"
    t.integer "year"
    t.date "start_date"
    t.date "end_date"
    t.string "cover_photo_url"
    t.boolean "agreed_to_publish", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author"
    t.index ["external_id"], name: "index_albums_on_external_id"
  end

  create_table "albums_places", id: false, force: :cascade do |t|
    t.bigint "album_id"
    t.bigint "place_id"
    t.index ["album_id"], name: "index_albums_places_on_album_id"
    t.index ["place_id"], name: "index_albums_places_on_place_id"
  end

  create_table "albums_tags", id: false, force: :cascade do |t|
    t.bigint "album_id"
    t.bigint "tag_id"
    t.index ["album_id"], name: "index_albums_tags_on_album_id"
    t.index ["tag_id"], name: "index_albums_tags_on_tag_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "album_id"
    t.string "external_id", null: false
    t.string "author"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_photos_on_album_id"
    t.index ["external_id"], name: "index_photos_on_external_id"
  end

  create_table "photos_places", id: false, force: :cascade do |t|
    t.bigint "photo_id"
    t.bigint "place_id"
    t.index ["photo_id"], name: "index_photos_places_on_photo_id"
    t.index ["place_id"], name: "index_photos_places_on_place_id"
  end

  create_table "photos_tags", id: false, force: :cascade do |t|
    t.bigint "photo_id"
    t.bigint "tag_id"
    t.index ["photo_id"], name: "index_photos_tags_on_photo_id"
    t.index ["tag_id"], name: "index_photos_tags_on_tag_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_token"
    t.string "encrypted_refresh_token"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "photos", "albums"
end
