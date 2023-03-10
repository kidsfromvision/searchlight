# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_08_220734) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "provider"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "spotify_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instagram_url"
    t.string "facebook_url"
    t.string "twitter_url"
  end

  create_table "geographies", force: :cascade do |t|
    t.string "country"
    t.string "city"
    t.integer "listeners"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "artist_id"
    t.string "region"
    t.index ["artist_id"], name: "index_geographies_on_artist_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "label_id"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.index ["label_id"], name: "index_invitations_on_label_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "song_request_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "song_id"
    t.integer "provider", default: 0
    t.integer "status", default: 0
    t.integer "data_requested", default: 0
    t.index ["song_id"], name: "index_song_request_events_on_song_id"
  end

  create_table "song_streams", force: :cascade do |t|
    t.integer "streams"
    t.datetime "date", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "song_id"
    t.integer "provider", default: 0
    t.index ["song_id"], name: "index_song_streams_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.string "spotify_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "art_url"
    t.string "icon_url"
    t.string "artist_id"
    t.date "released"
    t.string "genres"
  end

  create_table "spotify_api_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expiry", precision: nil
  end

  create_table "tracked_songs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "label_id"
    t.bigint "song_id"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.boolean "is_pinned", default: false
    t.boolean "archived", default: false
    t.index ["label_id"], name: "index_tracked_songs_on_label_id"
    t.index ["song_id"], name: "index_tracked_songs_on_song_id"
    t.index ["user_id"], name: "index_tracked_songs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "label_id"
    t.integer "role", default: 0
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["label_id"], name: "index_users_on_label_id"
    t.index ["reset_password_token"],
            name: "index_users_on_reset_password_token",
            unique: true
  end

  add_foreign_key "geographies", "artists"
  add_foreign_key "invitations", "labels"
  add_foreign_key "invitations", "users"
  add_foreign_key "song_request_events", "songs"
  add_foreign_key "song_streams", "songs"
  add_foreign_key "tracked_songs", "labels"
  add_foreign_key "tracked_songs", "songs"
  add_foreign_key "tracked_songs", "users"
  add_foreign_key "users", "labels"
end
